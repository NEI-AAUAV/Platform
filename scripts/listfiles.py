import sys
import glob 
import os
from zipfile import ZipFile
import json
import math
import mysql.connector


# SCRIPT DESCRIPTION
"""
This script analyses the content of a given folder individually.
The analysis is recursive, so every subfolder is analysed until the bottom of the hierarchy is reached.
For each file, the size is determined and if it is a ZIP file, its content is analysed and registered. 

The ZIP file content is structured in a called "ZIP folder dictionary", which has the following structure:
{
    "/": {
        "Pedro Oliveira": {
            "Cap3": {
                "Doppler_000001.jpg": {
                    "type": "file"
                },
                "Doppler_000002.jpg": {
                    "type": "file"
                }
            },
            "Somefile.pdf": {
                "type": "file"
            }
        },
        "type": "dir"
    },
    "type": "dir"
}

Its content is registered in a compressed way, following the criteria below (example for a folder with more than 2 hierarchycal levels).
/ (Level 1)
    file1.docx
    file2.pdf
    Folder1 (Level 2)
        abc.py
        test.pdf
        Folder2 (Level 3)
            3 files
            2 folders com X subfolders and Y files

Running in development environment: 
$ python3 listfiles.py true "uploads/primeiro_ano/**/**" "gmatos.pt" "aauav-nei" "aauavnei_admin" "Eqa8w16&"
"""


# PARAMETERS
"""
Get the execution parameteres.
"""
if len(sys.argv) not in [3, 7]:
    print("ERROR! Number of arguments provided is not valid!")
    print("\nExpected (Option 1, only analyse):\n$ python3 listfiles.py <ask for input? [true|false]> <folder to analyse>")
    print("Example: $ python3 listfiles.py false \"uploads/primeiro_ano/**/**\"")
    print("\nExpected (Option 2, analyse and update notes table on db):\n$ python3 listfiles.py <ask for input? [true|false]> <folder to analyse> <dbhost> <dbname> <dbuser> <dbpassword>")
    print("Example: $ python3 listfiles.py false \"uploads/primeiro_ano/**/**\" localhost dbname root password")
    exit()

ASK_FOR_INPUT = (sys.argv[1]=='true')  # For development only, asks for user to press ENTER for very file shown
FOLDER = sys.argv[2]
DB_DATA = None
if len(sys.argv)==7:
    DB_DATA = {
        'host': sys.argv[3],
        'table': sys.argv[4],
        'user': sys.argv[5],
        'password': sys.argv[6]
    } 

# UTILS
"""
This recursive method sets a dictionary value, given an array with the keys.
For example (mydict={}, ['a', 'b', 'c'], 2), will set mydict value to {'a': {'b': {'c': 2}}}
"""
def setKeysListValue(dataDict, mapList, value):
    if len(mapList)==1:
        dataDict[mapList[0]] = value
        return 
    elif mapList[0] not in dataDict:
        dataDict[mapList[0]] = {}
        dataDict[mapList[0]]['type'] = 'dir'
    setKeysListValue(dataDict[mapList[0]], mapList[1:], value)


"""
This recursive method analyses recursively the content of a ZIP folder dictionary and returns the number of files that match the key given as a parameter. 
"""
def countFolderKeys(mydic, key='dir'):
    return sum([1 if val['type'] == key else 0 for entry, val in mydic.items() if entry!='type']) + sum([countFolderKeys(val) for entry, val in mydic.items() if entry!='type' and val['type']=='dir'])

"""
This method converts a ZIP folder dictionary to a compressed String representation, according to the requirements defined in the script description.
"""
def structureDict(mydic, tabs=0, parent='', level=1):
    mystr = ''
    for entry, val in mydic.items():
        if entry=='type':
            continue        
        mystr += '\t'*tabs + f"{truncatefilename(entry)}\n"
        if val['type'] == 'dir':
            if level+1<3:
                mystr += structureDict(val, tabs=tabs+1, parent=f"{parent}{entry}/", level=level+1)
            else:
                mystr += '\t'*(tabs+1) + f"{countFolderKeys(val, 'dir')} directories\n"
                mystr += '\t'*(tabs+1) + f"{countFolderKeys(val, 'file')} files\n"
    return mystr


"""
This method shortens the name of files that have a name bigger than 14 chars, converting it to: <6 chars>...<4 chars>.<extension>
Example of shortened name: ABCKsH...anah.pdf
"""
def truncatefilename(filename):
    if len(filename)<=20:
        return filename
    extension = ''
    if '.' in filename and len(filename.split('.')[-1])<=5:
        extension = f"{filename.split('.')[-1]}"
        filename = '.'.join(filename.split('.')[:-1])
    return f"{filename[0:13]}...{extension}"


"""
This method analyses a file name and returns True if it should be displayed.
It ignores hidden and configuration files. 
"""
def showFile(filename):
    # Ignore unknown and strange folders
    if '/.' in filename:
        return False
    if len(filename) > 1 and filename[0:1] == '.':
        return False
    if '/__' in filename:
        return False
    if len(filename) > 2 and filename[0:3] == '__':
        return False
    return True


# ZIP ANALYSIS 
"""
Given a ZIP file, analysis its characteristics and internal structure
"""
def zip(filename):
    structure = dict()

    # Initialize structure with root folder: /
    setKeysListValue(structure, ['type'], 'dir')
    setKeysListValue(structure, ['/', 'type'], 'dir')

    # Get ZipFile object (https://docs.python.org/3/library/zipfile.html#zipfile-objects)
    zipObj = ZipFile(filename, 'r')

    # For each item inside (ZipInfo - https://docs.python.org/3/library/zipfile.html#zipinfo-objects)
    for i in zipObj.infolist():
        # Ignore unknown folders
        if not showFile(filename):
            continue
        # print('DIRE' if i.is_dir() else 'FILE', end="\t")
        # print(i.filename)

        # Add to structure
        current = list(filter(lambda e: e, i.filename.split('/')))
        current.insert(0, '/')
        
        setKeysListValue(structure, current, {})

        typetag = current
        typetag.append('type')

        setKeysListValue(structure, typetag, 'dir' if i.is_dir() else 'file')

    print('-- dict')
    print(json.dumps(structure, sort_keys=True, indent=4))

    print('-- my dict')
    structureStr = structureDict(structure)
    print(structureStr)
    return structureStr


# MAIN()
"""
Connect to the database (if arguments provided)
"""
connection = None
if DB_DATA:
    print('DB data provided in arguments, connecting...')
    try:
        connection = mysql.connector.connect(host=DB_DATA['host'],database=DB_DATA['table'],user=DB_DATA['user'],password=DB_DATA['password'])
        if connection.is_connected():
            db_Info = connection.get_server_info()
            print("Connected to MySQL Server version ", db_Info)
            cursor = connection.cursor()
            cursor.execute("select database();")
            record = cursor.fetchone()
            print("You're connected to database: ", record)
    except Exception as err:
        print("ERROR connecting to the database!")
        print("Error while connecting to MySQL", err)
        exit()

if ASK_FOR_INPUT:
    input('\nPress ENTER to continue...')

"""
Iterates through the folder subhierarchy to find and analyse its files
"""
counter = 0
counterValid = 0
counterInvalid = 0
counterDB = 0
dbDuplicates = []
# For every file inside FOLDER
for filename in glob.iglob(FOLDER, recursive=True):
    counter += 1

    # Check if is file (if not, continue)
    if os.path.isdir(filename):
        print(f"DIRE: {filename}")
        continue
    elif os.path.isfile(filename):
        counterValid += 1
        print(f"FILE: {filename}")
    else:
        counterInvalid += 1
        print(f"!UNK: {filename}")
        continue

    # This code is only reached if is file
    zipStructure = None
    if '.zip' in filename:
        zipStructure = zip(filename)

    size = os.path.getsize(filename) # Returns bytes
    size = math.ceil(size*0.000001) # Convert to mb
    print(f'File size is {size}mb')

    # If db connection, update statement
    if connection and cursor:
        print('Searching db for matching row...')
        cursor.execute(f'SELECT id, name, content, size FROM notes WHERE location="{filename.replace("uploads/", "/notes/")}"')
        myresult = cursor.fetchall()
        if len(myresult)==1:
            counterDB += 1
        else:
            print(f'ERROR DB! Got {len(myresult)} results matching this file location in the notes table!')
            dbDuplicates.append([row[0] for row in myresult])
        # Update values
        row = myresult[0]
        print(row)
        if zipStructure and not row[2]:
            print('Updating content...')
            cursor.execute(f'UPDATE notes SET content="{zipStructure}" WHERE ID={row[0]}')
            connection.commit()
        if not row[3]:
            print('Updating size...')
            cursor.execute(f'UPDATE notes SET size={size} WHERE ID={row[0]}')
            connection.commit()

    if ASK_FOR_INPUT:
        input('\nPress ENTER to continue...')

    print()


"""
Close connection to the db
"""
if connection and connection.is_connected():
    cursor.close()
    connection.close()
    print("MySQL connection is closed")

print(f'\n\nFinished analisis of folder, with {int(round((counterValid/counter)*100))}% success ({counterValid} valid files, out of {counter})!')
print(f'\nThe success rate updating the db was {(int(round((counterDB/counter)*100)))} ({counterDB} success updates, out of {counter}).')
if len(dbDuplicates):
    print(f'\nThere were {len(dbDuplicates)} duplicate entries found:')
    for entry in dbDuplicates:
        print(entry)
else:
    print('\nThere were no duplicate entries found! :)')
print(f'\nThe error rate was {(int(round((counterInvalid/counter)*100)))} ({counterInvalid} unknown files, out of {counter}).')
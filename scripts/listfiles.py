import glob 
import os
from zipfile import ZipFile
import json


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
"""


# GLOBAL VARIABLES
"""
Here are some variable that change the script behaviour.
"""
FOLDER = 'uploads/primeiro_ano/**/**'


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
    print(structureDict(structure))

    input()


# MAIN()
"""
Iterates through the folder subhierarchy to find and analyse its files
"""
# For every file inside FOLDER
for filename in glob.iglob(FOLDER, recursive=True):

    # Analyse ZIP files
    if os.path.isdir(filename):
        print(f"DIRE: {filename}")
    elif os.path.isfile(filename):
        print(f"FILE: {filename}")

        if '.zip' in filename:
            zip(filename)
    else:
        print(f"!UNK: {filename}")

    print()


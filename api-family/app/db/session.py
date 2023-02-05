from app.core.config import settings


# engine = create_engine(settings.MONGO_URI, echo=True)
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


from pymongo import MongoClient
import pymongo

client = MongoClient(settings.DATABASE_URL)
print('Connected to MongoDB...')

db = client[settings.MONGO_DB]
User = db.users
Post = db.posts
User.create_index([("email", pymongo.ASCENDING)], unique=True)
Post.create_index([("title", pymongo.ASCENDING)], unique=True)

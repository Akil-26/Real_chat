from fastapi import FastAPI
from Database.database import engine, Base
from models.user import User

app = FastAPI()

Base.metadata.create_all(bind=engine)

@app.get("/")
def root():
    return {"message": "DB connected successfully 🚀"}

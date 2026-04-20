import mongoose from "mongoose";


export interface IUser extends mongoose.Document {
    username: string,
    email: string,
    password: string
}



const userSchema = new mongoose.Schema<IUser>(

    {
        username: {
            require: true,
            type: String,

        },
        email: {
            type: String,
            required: true,
            unique: true
        },
        password: {
            type
                : String,
            required: true,


        }
    }, { timestamps: true }

);



export const User = mongoose.model<IUser>("user", userSchema);
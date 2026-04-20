import { Response, Request } from "express";

import bcrypt from 'bcrypt'

import z, { ZodError } from "zod";
import { User } from "../model/user.model";
import { signToken } from "../utils/token.utils";

const createUserSchema = z.object({
    username: z.string().min(3).max(20),
    email: z.email(),
    password: z.string().min(6).max(50),
});
const loginUserSchema = z.object({
    email: z.email(),
    password: z.string().min(6).max(50),
});



const login = async (req: Request, res: Response) => {

    try {
        const { email, password } = loginUserSchema.parse(req.body);

        const existsUser = await User.findOne({ email });

        if (!existsUser) {
            res.status(400).json({ error: "Invalid email and password" });
            return;
        }

        const validatePassword = await bcrypt.compare(password, existsUser.password);

        if (!validatePassword) {
            res.status(400).json({ error: "Invalid email and password" });
            return;

        }
        const token = signToken({
            id: existsUser._id.toString(), email: existsUser.email
        });

        res.status(201).json({user: { id: existsUser._id, email: existsUser.email, username: existsUser.username}, token });

        return;




    } catch (error) {

        if (error instanceof ZodError) {
            res.status(400).json({ error, message: "invalid request body" });
        } else {
            res.status(500).json({ error, message: "something went wrong" });
        }
    }


}
const register = async (req: Request, res: Response) => {

    try {
        const data = createUserSchema.parse(req.body);

        const { email, username, password } = data;

        const existingUser = await User.findOne({ "$or": [{ email, username }] });

        if (existingUser) {

            res.status(400).json({ error: "username and email already exists" });
            return;
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = await User.create({ email, username, password: hashedPassword });
        const token = signToken({
            id: newUser._id.toString(), email: newUser.email
        });

        res.status(201).json({ user : {id : newUser._id, email: newUser.email, username: newUser.username}, token });
        return;

    } catch (error) {

        if (error instanceof ZodError) {
            res.status(200).json({ error, message: "invalid request body" });
        } else {
            res.status(500).json({ error, message: "Something went Wrong while creating the eror" });
        }

    }
}

const verify = async (req: Request, res: Response) => {
    try {
        const userId = req.userId;
        const user = await User.findById(userId).select('-password');
        
        if (!user) {
            res.status(401).json({ error: "User not found or deleted" });
            return;
        }

        res.status(200).json({ user: { id: user._id, email: user.email, username: user.username }, valid: true });
        return;
    } catch (error) {
        res.status(500).json({ error, message: "Something went wrong during verification" });
        return ;
    }
}

export { login, register, verify }

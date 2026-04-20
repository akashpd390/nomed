


import jwt, { SignOptions } from "jsonwebtoken";
import { env } from "../config/env";

export interface JwtPayload {
    id: string;
    email: string;
}


export const signToken = (
    payload: JwtPayload,
    options?: SignOptions
): string => {
    return jwt.sign(payload, env.JWT_SECRET, {
        expiresIn: "1d",
        ...options
    });
};


export const verifyToken = <T = JwtPayload>(token: string): T => {
    return jwt.verify(token, env.JWT_SECRET) as T;
};

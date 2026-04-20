import { Request, Response, NextFunction } from "express"
import { verifyToken } from "../utils/token.utils";




const authMiddleware = async (req: Request, res: Response, next: NextFunction) => {

    try {
        const authHeader = req.headers.authorization;

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            res.status(401).json({ error: "token not found" });
            return;
        }

        const token = authHeader.split(" ")[1];

        const decoded = verifyToken(token,);
        if (!decoded) {
            res.status(401).json({ error: "tokken is invalid" });
            return;

        }

        req.userId = decoded.id;
        next();

    } catch (error) {

        res.status(401).json({ error, message: "Unauthorized" });

    }

}


export default authMiddleware;
import mongoose from "mongoose";
import z from "zod";


export const objectIdSchema = z.string()
    .trim()
    .min(1)
    .refine(
        (id) => mongoose.Types.ObjectId.isValid(id),
        { message: "not valid mongoose id " }
    )
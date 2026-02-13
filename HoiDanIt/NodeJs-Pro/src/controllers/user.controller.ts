import { Request, Response } from "express";
import { handleUserCreate } from "../services/user.service";

const getHomePage = (req: Request, res: Response) => {
    return res.render("home"); // Render the home.ejs view
}

const getCreateUser = (req: Request, res: Response) => {
    return res.render("create-user.ejs"); // Render the create-user.ejs view
}

const postCreateUser = (req: Request, res: Response) => {
    console.log("Received POST request to create user:", req.body);
    // Object destructuring to get form data
    const { name, email, address } = req.body;
    console.log(`Name: ${name}, Email: ${email}, Address: ${address}`);

    // Handle creation logic here (e.g., save to database)
    handleUserCreate(name, email, address);

    return res.redirect("/"); // Redirect to home page after handling form submission
}

export { getHomePage, getCreateUser, postCreateUser };
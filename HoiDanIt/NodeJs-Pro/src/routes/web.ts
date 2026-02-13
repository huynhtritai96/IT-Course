import express, {Express} from "express";
import { getCreateUser, getHomePage, postCreateUser } from "../controllers/user.controller";

const router = express.Router();

const webRoutes = (app: Express) => { // function to define web routes
    // Define a route for the home page
    // router.get("/", (req, res) => {
    //     res.render("home"); // Render the home.ejs view
    // });
    router.get("/", getHomePage); // not getHomePage() to avoid immediate invocation
    router.get("/create-user", getCreateUser);
    router.post("/handle-create-user", postCreateUser); // TODO: handle form submit

    router.get("/about", (req, res) => {
        res.send("This is about page");
        // res.render("about"); // Render the about.ejs view
    });

    router.get("/contact", (req, res) => {
        res.send("This is contact page");
        // res.render("contact"); // Render the contact.ejs view
    });

    app.use("/", router); // root route that routes to other paths
}


export default webRoutes;

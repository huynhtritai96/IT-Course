import e from "express";

const handleUserCreate = (
    fullName: string,
    email: string,
    address: string) => {
    // console.log('User created successfully! Enter User.Service.ts to implement logic.');
    console.log("Creating user with details:", fullName, email, address);

    // Insert into database logic here

    // return result
    console.log(">>> insert new user into database successfully!");

}

export { handleUserCreate };
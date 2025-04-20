const express = require('express');
const userRouter = require('./routes/user_router');


const app = express();

app.use(userRouter);




const PORT = 3000;
app.listen(PORT, () => {
    console.log('Server is running on port ${PORT}');
})



app.use(express.json());
app.use(express.urlencoded({ extended: true }));
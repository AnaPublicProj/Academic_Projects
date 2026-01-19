import turtle
import time
import random

# Setup the screen variables globally first so they exist
wn = turtle.Screen()
wn.title("Pong")
wn.bgcolor("black")
wn.setup(width=800, height=600)
wn.tracer(0)

# Global lists
blocks = []
blockshit = []

def main():
    # Clear the menu text
    start.clear()
    quit.clear()
    pen.clear()
    
    # Define colors inside main or use global
    colors = ['red','blue','yellow']

    # Paddle
    paddle = turtle.Turtle()
    paddle.speed(0)
    paddle.shape("square")
    paddle.color("white")
    paddle.penup()
    paddle.shapesize(stretch_wid = 1, stretch_len = 5)
    paddle.goto(0, -200)

    # Ball
    ball = turtle.Turtle()
    ball.speed(0)
    ball.shape('square')
    ball.color(random.choice(colors))
    ball.penup()
    ball.shapesize(stretch_wid =1, stretch_len=1)
    ball.goto(0, -100)
    ball.dx = 0.8
    ball.dy = 0.8

    # Create Blocks
    for j in range(280, 205, -25):
        for i in range(-345, 370, 65):
            block = turtle.Turtle()
            block.speed(0)
            block.shape('square')
            block.color(random.choice(colors))
            block.penup()
            block.shapesize(stretch_wid = 1, stretch_len=3)
            block.goto(i, j)
            blocks.append(block)

    # Functions
    def moveright():
        x = paddle.xcor()
        x += 20
        paddle.setx(x)

    def moveleft():
        x = paddle.xcor()
        x -= 20
        paddle.setx(x)

    def check_collision():
        for block in blocks:
            if (block.xcor() < ball.xcor() + 30 and 
                block.xcor() > ball.xcor() - 30 and 
                ball.ycor() > block.ycor() - 10 and 
                ball.ycor() < block.ycor() + 10):
                
                ball.dy *= -1
                ball.sety(block.ycor() - 20)
                
                # Hide the block
                block.goto(1000, 1000)
                # Remove from active blocks list theoretically, 
                # but for now we just move it away
                
                if ball.color() == block.color():
                    # Special logic if colors match
                    pass
                else:
                    ball.color(random.choice(colors))

    # Controls
    wn.listen()
    wn.onkeypress(moveright, 'd')
    wn.onkeypress(moveleft, 'a')

    # Main Game Loop
    while True:
        wn.update() # Update screen

        # Move ball
        ball.sety(ball.ycor() + ball.dy)
        ball.setx(ball.xcor() + ball.dx)

        # Border Checking
        if ball.xcor() > 390:
            ball.setx(390)
            ball.dx *= -1
        if ball.xcor() < -390:
            ball.setx(-390)
            ball.dx *= -1
        if ball.ycor() > 290:
            ball.sety(290)
            ball.dy *= -1
        if ball.ycor() < -290:
            ball.goto(0, 0)
            ball.dy *= -1

        # Paddle Collision
        if (ball.xcor() < paddle.xcor() + 50 and 
            ball.xcor() > paddle.xcor() - 50 and 
            ball.ycor() < -190 and ball.ycor() > -200):
            ball.sety(-190)
            ball.dy *= -1
            
        check_collision()

# --- Initial Menu Setup ---

# Title
pen = turtle.Turtle()
pen.speed(0)
pen.color('white')
pen.penup()
pen.hideturtle()
pen.goto(0, 200)
pen.write("Brick Breaker", align="center", font=('Arial', 36, 'normal'))

# Start Instructions
start = turtle.Turtle()
start.speed(0)
start.color('white')
start.penup()
start.hideturtle()
start.goto(0, 100)
start.write("PRESS 'ENTER' TO START", align="center", font=('Arial', 16, 'normal'))

# Quit Instructions
quit = turtle.Turtle()
quit.speed(0)
quit.color('white')
quit.penup()
quit.hideturtle()
quit.goto(0, 50)
quit.write("Press 'd' to move right, 'a' to move left", align="center", font=('Arial', 12, 'normal'))

# Key Bindings to start game
wn.listen()
wn.onkey(main, 'Return') # Return means the Enter key

wn.mainloop()
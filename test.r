
# PLAYING WITH VECTORS

n       <- c( 1, 2, 3, 4, 5, 6, 7,  8,  9, 10, 11 )
vec     <- c( 1, 2, 3, 4, 5, 6, 5,  4,  3,  2, 1  ) 
vec2    <- c( 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 )
vec3    <- rev(vec2)
p_cols  <- c( "blue" , "red" , "orange" , "green" ) 
yrange  <- range( 0 , vec , vec2 , vec3 )

plot (
    vec3 ,
    col=p_cols[1] ,
    type="l" ,
    xlab="X" ,
    ylab="Y" ,
    ylim=yrange
    )

plot (
    vec2 ,
    col=p_cols[1] ,
    type="b" ,
    xlab="X" ,
    ylab="Y" ,
    ylim=yrange
    )

plot (
    vec ,
    col=p_cols[1] ,
    type="p" ,
    xlab="X" ,
    ylab="Y" ,
    ylim=yrange
    )
lines(
    vec2 ,
    col=p_cols[2] ,
    type="p"
    )
lines(
    vec3 ,
    col=p_cols[3] ,
    type="p"
    )



# PLAYING WITH DATA FRAMES

i <- c(1 ,2 ,3 ,4 ,5 ,6 ,7 ,8 ,9 ,10 ,11 ,12 ,13 ,14 ,15 ,16 ,17 ,18 ,19 ,20 )
f <- c(0 , 1 , 1 , 2 , 3 , 5 , 8 , 13 , 21 , 34 , 55 , 89 , 144 , 233 , 377 , 610 , 987 , 1597 , 2584 , 4181)

fib <- data.frame( i,f)
head(fib)
colnames(fib) <- c('index','fibonacci')
head(fib)

# p = points
# l = lines
# b = both

plot(fib, type='p')
plot(fib, type='l')
plot(fib, type='b')

# after ggplot2
library('ggplot2')
ggplot( fib , aes( x=index,y=fibonacci ) )+geom_bar(stat="identity") 
ggplot( fib , aes( x=index,y=fibonacci ) )+geom_line()

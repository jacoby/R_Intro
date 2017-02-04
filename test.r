
vec  <- c( 1, 2, 3, 4, 5, 6, 5,  4,  3,  2, 1 ) 
vec2 <- c( 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 )
vec3 <- rev(vec2)
p_cols      <- c( "blue" , "red" , "orange" , "green" ) 
yrange <- range( 0 , vec , vec2 , vec3 )

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

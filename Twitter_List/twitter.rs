#!/usr/bin/Rscript

#   Cairo   - for creating images outside of X
#   ggplot2 - the MAGIC

suppressPackageStartupMessages( require( "Cairo"    , quietly=TRUE ) )
suppressPackageStartupMessages( require( "ggplot2"  , quietly=TRUE ) )

# read in CSV
#       from,to,val
#       davorg,merlyn,1
#       davorg,gnat,1
mydata = read.csv('output.csv') 

# only necessary if you don't make sure it's not set in CSV
#colnames(mydata) <- c("from","to","val")

# show what data looks like
#head(mydata)

# Cairo makes images without X11
CairoPNG(
    filename    = "./matrix.png" ,
    width       = 2000  ,
    height      = 2000  ,
    pointsize   = 16
    )

# aes -> aesthetics
ggplot(
    data = mydata, 
    aes(
        x=from, 
        y=to, 
        fill=val,
        )
    ) + 
geom_raster(
    ) +
theme_grey( base_size = 16, base_family = "" ) + 
theme(
    axis.text.x = element_text(
        size = 16, 
#         vjust = 1, 
        hjust = 1,
        angle = 90 
        )
    ) +
coord_fixed()


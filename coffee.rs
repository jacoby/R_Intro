#!/usr/bin/Rscript

#   Cairo   - for creating images outside of X
#   ggplot2 - the MAGIC
#   RMySQL  - for interacting with the MySQL database
#   yaml    - for storing database credentials

suppressPackageStartupMessages( require( "Cairo"   , quietly=TRUE ) )
suppressPackageStartupMessages( require( "ggplot2" , quietly=TRUE ) )
suppressPackageStartupMessages( require( "RMySQL"  , quietly=TRUE ) )
suppressPackageStartupMessages( require( "yaml"    , quietly=TRUE ) )

# administrivia 
my.cnf = yaml.load_file( '~/.my.yaml' )
database = my.cnf$clients$itap
quote       <- "'"
newline     <- "\n"

# the query
coffee_sql <- "
    SELECT
            YEAR(d.datestamp) year ,
            IF(
                WEEKDAY(d.datestamp) > 5 ,
                1 ,
                2 + WEEKDAY(d.datestamp) 
                ) wday ,
            WEEK(d.datestamp) week ,

            COUNT(c.cups) cups ,
            DATE(d.datestamp) date 

    FROM    day_list d
    LEFT OUTER JOIN coffee_intake c
    ON DATE(c.datestamp) = DATE(d.datestamp)
    WHERE   DATE(d.datestamp) > '2012-11-01'
    AND     DATE(d.datestamp) <= DATE(NOW())
    GROUP BY DATE(d.datestamp)
    ORDER BY DATE(d.datestamp)
"

con <- dbConnect(
    MySQL(),
    user=database$user ,
    password=database$password,
    dbname=database$database,
    host=database$host
    )

coffee.data  <- dbGetQuery( con , coffee_sql )

CairoPNG(
    filename    = "/home/jacoby/www/coffee.png" ,
    width       = 600  ,
    height      = 600  ,
    pointsize   = 12
    )

ggplot(
    coffee.data, 
    aes( week, wday, fill = cups ) ) +
        geom_tile(colour = "#191412") +
        ggtitle( "Dave Jacoby's Coffee Intake" ) +
        xlab( 'Week of the Year' ) +
        ylab( 'Day of the Week' ) +
        scale_fill_gradientn(
            colours = c(
                "#d1c3be",
                "#a78b83",
                "#4b3a35"
                )
            ) + 
        facet_wrap(~ year, ncol = 1) 


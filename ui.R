library(shiny)
library(shinyAce)
library(lme4)



shinyUI(bootstrapPage(


    headerPanel("Generalizability Theory"),

        sidebarPanel(

            radioButtons("type", strong("Design (all crossed):"),
                        list("p × i" = "pi",
                             "p × r × i" = "pri") , selected = "pri"

            ),

            br()

        ),



    mainPanel(

        tabsetPanel(

        tabPanel("Main",

            p('Note: Input values must be separated by tabs. Copy and paste from Excel/Numbers.'),

            p(HTML("<b><div style='background-color:#FADDF2;border:1px solid black;'>Your data needs to have exactly the same header (variable names) in the first row.</div></b>")),

            br(),

            aceEditor("text", value="Student\tRater\tItem\tScore\n1\t1\t1\t5\n1\t2\t1\t2\n1\t3\t1\t7\n1\t4\t1\t6\n1\t5\t1\t6\n1\t6\t1\t6\n1\t7\t1\t5\n1\t8\t1\t2\n1\t1\t2\t4\n1\t2\t2\t2\n1\t3\t2\t6\n1\t4\t2\t6\n1\t5\t2\t3\n1\t6\t2\t6\n1\t7\t2\t5\n1\t8\t2\t2\n1\t1\t3\t3\n1\t2\t3\t3\n1\t3\t3\t7\n1\t4\t3\t6\n1\t5\t3\t5\n1\t6\t3\t7\n1\t7\t3\t6\n1\t8\t3\t3\n1\t1\t4\t3\n1\t2\t4\t2\n1\t3\t4\t7\n1\t4\t4\t6\n1\t5\t4\t5\n1\t6\t4\t7\n1\t7\t4\t6\n1\t8\t4\t3\n1\t1\t5\t4\n1\t2\t5\t3\n1\t3\t5\t7\n1\t4\t5\t6\n1\t5\t5\t5\n1\t6\t5\t7\n1\t7\t5\t6\n1\t8\t5\t3\n1\t1\t6\t3\n1\t2\t6\t3\n1\t3\t6\t6\n1\t4\t6\t6\n1\t5\t6\t5\n1\t6\t6\t5\n1\t7\t6\t5\n1\t8\t6\t3\n2\t1\t1\t5\n2\t2\t1\t3\n2\t3\t1\t7\n2\t4\t1\t7\n2\t5\t1\t6\n2\t6\t1\t7\n2\t7\t1\t6\n2\t8\t1\t4\n2\t1\t2\t5\n2\t2\t2\t3\n2\t3\t2\t7\n2\t4\t2\t7\n2\t5\t2\t5\n2\t6\t2\t7\n2\t7\t2\t6\n2\t8\t2\t4\n2\t1\t3\t4\n2\t2\t3\t3\n2\t3\t3\t7\n2\t4\t3\t7\n2\t5\t3\t5\n2\t6\t3\t6\n2\t7\t3\t6\n2\t8\t3\t3\n2\t1\t4\t4\n2\t2\t4\t3\n2\t3\t4\t7\n2\t4\t4\t7\n2\t5\t4\t5\n2\t6\t4\t6\n2\t7\t4\t6\n2\t8\t4\t3\n2\t1\t5\t3\n2\t2\t5\t4\n2\t3\t5\t7\n2\t4\t5\t7\n2\t5\t5\t5\n2\t6\t5\t6\n2\t7\t5\t6\n2\t8\t5\t3\n2\t1\t6\t4\n2\t2\t6\t3\n2\t3\t6\t6\n2\t4\t6\t7\n2\t5\t6\t5\n2\t6\t6\t5\n2\t7\t6\t5\n2\t8\t6\t3\n3\t1\t1\t5\n3\t2\t1\t2\n3\t3\t1\t7\n3\t4\t1\t5\n3\t5\t1\t6\n3\t6\t1\t6\n3\t7\t1\t5\n3\t8\t1\t2\n3\t1\t2\t3\n3\t2\t2\t2\n3\t3\t2\t7\n3\t4\t2\t5\n3\t5\t2\t4\n3\t6\t2\t6\n3\t7\t2\t5\n3\t8\t2\t2\n3\t1\t3\t3\n3\t2\t3\t2\n3\t3\t3\t7\n3\t4\t3\t5\n3\t5\t3\t5\n3\t6\t3\t6\n3\t7\t3\t6\n3\t8\t3\t4\n3\t1\t4\t4\n3\t2\t4\t3\n3\t3\t4\t7\n3\t4\t4\t5\n3\t5\t4\t4\n3\t6\t4\t6\n3\t7\t4\t6\n3\t8\t4\t4\n3\t1\t5\t4\n3\t2\t5\t3\n3\t3\t5\t8\n3\t4\t5\t6\n3\t5\t5\t4\n3\t6\t5\t6\n3\t7\t5\t6\n3\t8\t5\t4\n3\t1\t6\t4\n3\t2\t6\t3\n3\t3\t6\t6\n3\t4\t6\t6\n3\t5\t6\t5\n3\t6\t6\t5\n3\t7\t6\t5\n3\t8\t6\t2\n4\t1\t1\t6\n4\t2\t1\t4\n4\t3\t1\t8\n4\t4\t1\t6\n4\t5\t1\t7\n4\t6\t1\t7\n4\t7\t1\t7\n4\t8\t1\t3\n4\t1\t2\t4\n4\t2\t2\t5\n4\t3\t2\t7\n4\t4\t2\t6\n4\t5\t2\t5\n4\t6\t2\t7\n4\t7\t2\t6\n4\t8\t2\t3\n4\t1\t3\t4\n4\t2\t3\t6\n4\t3\t3\t8\n4\t4\t3\t6\n4\t5\t3\t5\n4\t6\t3\t5\n4\t7\t3\t6\n4\t8\t3\t2\n4\t1\t4\t5\n4\t2\t4\t6\n4\t3\t4\t8\n4\t4\t4\t6\n4\t5\t4\t5\n4\t6\t4\t6\n4\t7\t4\t6\n4\t8\t4\t2\n4\t1\t5\t4\n4\t2\t5\t6\n4\t3\t5\t8\n4\t4\t5\t7\n4\t5\t5\t5\n4\t6\t5\t5\n4\t7\t5\t6\n4\t8\t5\t2\n4\t1\t6\t4\n4\t2\t6\t6\n4\t3\t6\t6\n4\t4\t6\t6\n4\t5\t6\t5\n4\t6\t6\t5\n4\t7\t6\t5\n4\t8\t6\t3\n5\t1\t1\t5\n5\t2\t1\t3\n5\t3\t1\t5\n5\t4\t1\t5\n5\t5\t1\t4\n5\t6\t1\t7\n5\t7\t1\t5\n5\t8\t1\t1\n5\t1\t2\t4\n5\t2\t2\t3\n5\t3\t2\t7\n5\t4\t2\t5\n5\t5\t2\t4\n5\t6\t2\t6\n5\t7\t2\t5\n5\t8\t2\t1\n5\t1\t3\t3\n5\t2\t3\t4\n5\t3\t3\t7\n5\t4\t3\t5\n5\t5\t3\t2\n5\t6\t3\t6\n5\t7\t3\t6\n5\t8\t3\t2\n5\t1\t4\t3\n5\t2\t4\t4\n5\t3\t4\t6\n5\t4\t4\t5\n5\t5\t4\t2\n5\t6\t4\t6\n5\t7\t4\t6\n5\t8\t4\t2\n5\t1\t5\t3\n5\t2\t5\t4\n5\t3\t5\t7\n5\t4\t5\t5\n5\t5\t5\t2\n5\t6\t5\t6\n5\t7\t5\t6\n5\t8\t5\t1\n5\t1\t6\t3\n5\t2\t6\t4\n5\t3\t6\t6\n5\t4\t6\t5\n5\t5\t6\t3\n5\t6\t6\t5\n5\t7\t6\t5\n5\t8\t6\t1\n6\t1\t1\t5\n6\t2\t1\t5\n6\t3\t1\t8\n6\t4\t1\t6\n6\t5\t1\t7\n6\t6\t1\t7\n6\t7\t1\t7\n6\t8\t1\t4\n6\t1\t2\t4\n6\t2\t2\t4\n6\t3\t2\t8\n6\t4\t2\t6\n6\t5\t2\t5\n6\t6\t2\t7\n6\t7\t2\t6\n6\t8\t2\t4\n6\t1\t3\t3\n6\t2\t3\t3\n6\t3\t3\t7\n6\t4\t3\t6\n6\t5\t3\t4\n6\t6\t3\t5\n6\t7\t3\t6\n6\t8\t3\t4\n6\t1\t4\t4\n6\t2\t4\t4\n6\t3\t4\t7\n6\t4\t4\t6\n6\t5\t4\t4\n6\t6\t4\t6\n6\t7\t4\t6\n6\t8\t4\t4\n6\t1\t5\t3\n6\t2\t5\t4\n6\t3\t5\t8\n6\t4\t5\t6\n6\t5\t5\t5\n6\t6\t5\t5\n6\t7\t5\t6\n6\t8\t5\t4\n6\t1\t6\t4\n6\t2\t6\t4\n6\t3\t6\t6\n6\t4\t6\t6\n6\t5\t6\t5\n6\t6\t6\t5\n6\t7\t6\t5\n6\t8\t6\t4\n7\t1\t1\t6\n7\t2\t1\t6\n7\t3\t1\t7\n7\t4\t1\t5\n7\t5\t1\t6\n7\t6\t1\t7\n7\t7\t1\t7\n7\t8\t1\t3\n7\t1\t2\t5\n7\t2\t2\t5\n7\t3\t2\t6\n7\t4\t2\t5\n7\t5\t2\t4\n7\t6\t2\t7\n7\t7\t2\t6\n7\t8\t2\t4\n7\t1\t3\t4\n7\t2\t3\t6\n7\t3\t3\t6\n7\t4\t3\t5\n7\t5\t3\t4\n7\t6\t3\t6\n7\t7\t3\t6\n7\t8\t3\t3\n7\t1\t4\t4\n7\t2\t4\t6\n7\t3\t4\t6\n7\t4\t4\t5\n7\t5\t4\t4\n7\t6\t4\t6\n7\t7\t4\t6\n7\t8\t4\t3\n7\t1\t5\t4\n7\t2\t5\t6\n7\t3\t5\t6\n7\t4\t5\t5\n7\t5\t5\t5\n7\t6\t5\t6\n7\t7\t5\t6\n7\t8\t5\t4\n7\t1\t6\t4\n7\t2\t6\t6\n7\t3\t6\t6\n7\t4\t6\t5\n7\t5\t6\t4\n7\t6\t6\t5\n7\t7\t6\t5\n7\t8\t6\t3\n8\t1\t1\t6\n8\t2\t1\t3\n8\t3\t1\t7\n8\t4\t1\t7\n8\t5\t1\t7\n8\t6\t1\t7\n8\t7\t1\t7\n8\t8\t1\t5\n8\t1\t2\t5\n8\t2\t2\t3\n8\t3\t2\t7\n8\t4\t2\t7\n8\t5\t2\t5\n8\t6\t2\t7\n8\t7\t2\t5\n8\t8\t2\t5\n8\t1\t3\t3\n8\t2\t3\t3\n8\t3\t3\t6\n8\t4\t3\t6\n8\t5\t3\t4\n8\t6\t3\t6\n8\t7\t3\t5\n8\t8\t3\t4\n8\t1\t4\t3\n8\t2\t4\t4\n8\t3\t4\t7\n8\t4\t4\t6\n8\t5\t4\t4\n8\t6\t4\t6\n8\t7\t4\t6\n8\t8\t4\t5\n8\t1\t5\t4\n8\t2\t5\t3\n8\t3\t5\t6\n8\t4\t5\t7\n8\t5\t5\t4\n8\t6\t5\t5\n8\t7\t5\t7\n8\t8\t5\t5\n8\t1\t6\t4\n8\t2\t6\t4\n8\t3\t6\t6\n8\t4\t6\t6\n8\t5\t6\t4\n8\t6\t6\t5\n8\t7\t6\t5\n8\t8\t6\t5\n9\t1\t1\t6\n9\t2\t1\t4\n9\t3\t1\t8\n9\t4\t1\t6\n9\t5\t1\t7\n9\t6\t1\t8\n9\t7\t1\t7\n9\t8\t1\t6\n9\t1\t2\t5\n9\t2\t2\t4\n9\t3\t2\t8\n9\t4\t2\t6\n9\t5\t2\t7\n9\t6\t2\t8\n9\t7\t2\t7\n9\t8\t2\t6\n9\t1\t3\t4\n9\t2\t3\t3\n9\t3\t3\t6\n9\t4\t3\t5\n9\t5\t3\t5\n9\t6\t3\t5\n9\t7\t3\t6\n9\t8\t3\t4\n9\t1\t4\t3\n9\t2\t4\t3\n9\t3\t4\t6\n9\t4\t4\t5\n9\t5\t4\t5\n9\t6\t4\t6\n9\t7\t4\t6\n9\t8\t4\t4\n9\t1\t5\t4\n9\t2\t5\t3\n9\t3\t5\t6\n9\t4\t5\t5\n9\t5\t5\t5\n9\t6\t5\t5\n9\t7\t5\t6\n9\t8\t5\t4\n9\t1\t6\t4\n9\t2\t6\t3\n9\t3\t6\t6\n9\t4\t6\t5\n9\t5\t6\t5\n9\t6\t6\t5\n9\t7\t6\t5\n9\t8\t6\t4\n10\t1\t1\t6\n10\t2\t1\t6\n10\t3\t1\t8\n10\t4\t1\t7\n10\t5\t1\t7\n10\t6\t1\t7\n10\t7\t1\t7\n10\t8\t1\t5\n10\t1\t2\t5\n10\t2\t2\t6\n10\t3\t2\t9\n10\t4\t2\t7\n10\t5\t2\t7\n10\t6\t2\t7\n10\t7\t2\t7\n10\t8\t2\t5\n10\t1\t3\t5\n10\t2\t3\t7\n10\t3\t3\t8\n10\t4\t3\t7\n10\t5\t3\t5\n10\t6\t3\t5\n10\t7\t3\t6\n10\t8\t3\t5\n10\t1\t4\t4\n10\t2\t4\t7\n10\t3\t4\t8\n10\t4\t4\t7\n10\t5\t4\t5\n10\t6\t4\t6\n10\t7\t4\t6\n10\t8\t4\t5\n10\t1\t5\t4\n10\t2\t5\t7\n10\t3\t5\t8\n10\t4\t5\t7\n10\t5\t5\t5\n10\t6\t5\t5\n10\t7\t5\t6\n10\t8\t5\t4\n10\t1\t6\t4\n10\t2\t6\t7\n10\t3\t6\t6\n10\t4\t6\t7\n10\t5\t6\t5\n10\t6\t6\t5\n10\t7\t6\t5\n10\t8\t6\t4\n11\t1\t1\t6\n11\t2\t1\t7\n11\t3\t1\t7\n11\t4\t1\t6\n11\t5\t1\t7\n11\t6\t1\t7\n11\t7\t1\t7\n11\t8\t1\t4\n11\t1\t2\t5\n11\t2\t2\t6\n11\t3\t2\t7\n11\t4\t2\t6\n11\t5\t2\t7\n11\t6\t2\t7\n11\t7\t2\t7\n11\t8\t2\t4\n11\t1\t3\t4\n11\t2\t3\t6\n11\t3\t3\t7\n11\t4\t3\t5\n11\t5\t3\t5\n11\t6\t3\t6\n11\t7\t3\t7\n11\t8\t3\t5\n11\t1\t4\t4\n11\t2\t4\t6\n11\t3\t4\t7\n11\t4\t4\t5\n11\t5\t4\t5\n11\t6\t4\t6\n11\t7\t4\t6\n11\t8\t4\t5\n11\t1\t5\t3\n11\t2\t5\t5\n11\t3\t5\t7\n11\t4\t5\t5\n11\t5\t5\t5\n11\t6\t5\t5\n11\t7\t5\t6\n11\t8\t5\t5\n11\t1\t6\t4\n11\t2\t6\t5\n11\t3\t6\t6\n11\t4\t6\t5\n11\t5\t6\t6\n11\t6\t6\t5\n11\t7\t6\t5\n11\t8\t6\t5\n12\t1\t1\t6\n12\t2\t1\t6\n12\t3\t1\t7\n12\t4\t1\t6\n12\t5\t1\t7\n12\t6\t1\t7\n12\t7\t1\t7\n12\t8\t1\t4\n12\t1\t2\t5\n12\t2\t2\t5\n12\t3\t2\t8\n12\t4\t2\t6\n12\t5\t2\t7\n12\t6\t2\t7\n12\t7\t2\t6\n12\t8\t2\t4\n12\t1\t3\t4\n12\t2\t3\t6\n12\t3\t3\t8\n12\t4\t3\t6\n12\t5\t3\t4\n12\t6\t3\t5\n12\t7\t3\t6\n12\t8\t3\t4\n12\t1\t4\t3\n12\t2\t4\t6\n12\t3\t4\t8\n12\t4\t4\t6\n12\t5\t4\t4\n12\t6\t4\t6\n12\t7\t4\t6\n12\t8\t4\t5\n12\t1\t5\t3\n12\t2\t5\t6\n12\t3\t5\t7\n12\t4\t5\t6\n12\t5\t5\t4\n12\t6\t5\t5\n12\t7\t5\t6\n12\t8\t5\t5\n12\t1\t6\t3\n12\t2\t6\t6\n12\t3\t6\t6\n12\t4\t6\t6\n12\t5\t6\t6\n12\t6\t6\t5\n12\t7\t6\t5\n12\t8\t6\t4\n13\t1\t1\t6\n13\t2\t1\t6\n13\t3\t1\t7\n13\t4\t1\t7\n13\t5\t1\t7\n13\t6\t1\t7\n13\t7\t1\t7\n13\t8\t1\t5\n13\t1\t2\t5\n13\t2\t2\t6\n13\t3\t2\t7\n13\t4\t2\t7\n13\t5\t2\t5\n13\t6\t2\t7\n13\t7\t2\t6\n13\t8\t2\t5\n13\t1\t3\t4\n13\t2\t3\t7\n13\t3\t3\t6\n13\t4\t3\t7\n13\t5\t3\t4\n13\t6\t3\t6\n13\t7\t3\t6\n13\t8\t3\t5\n13\t1\t4\t3\n13\t2\t4\t7\n13\t3\t4\t7\n13\t4\t4\t7\n13\t5\t4\t4\n13\t6\t4\t6\n13\t7\t4\t6\n13\t8\t4\t5\n13\t1\t5\t3\n13\t2\t5\t7\n13\t3\t5\t6\n13\t4\t5\t7\n13\t5\t5\t4\n13\t6\t5\t5\n13\t7\t5\t6\n13\t8\t5\t4\n13\t1\t6\t4\n13\t2\t6\t7\n13\t3\t6\t6\n13\t4\t6\t7\n13\t5\t6\t4\n13\t6\t6\t5\n13\t7\t6\t5\n13\t8\t6\t4\n14\t1\t1\t7\n14\t2\t1\t6\n14\t3\t1\t7\n14\t4\t1\t5\n14\t5\t1\t7\n14\t6\t1\t7\n14\t7\t1\t6\n14\t8\t1\t6\n14\t1\t2\t5\n14\t2\t2\t6\n14\t3\t2\t7\n14\t4\t2\t5\n14\t5\t2\t7\n14\t6\t2\t7\n14\t7\t2\t6\n14\t8\t2\t5\n14\t1\t3\t5\n14\t2\t3\t7\n14\t3\t3\t7\n14\t4\t3\t5\n14\t5\t3\t5\n14\t6\t3\t6\n14\t7\t3\t6\n14\t8\t3\t5\n14\t1\t4\t4\n14\t2\t4\t7\n14\t3\t4\t5\n14\t4\t4\t5\n14\t5\t4\t5\n14\t6\t4\t6\n14\t7\t4\t6\n14\t8\t4\t5\n14\t1\t5\t3\n14\t2\t5\t7\n14\t3\t5\t7\n14\t4\t5\t5\n14\t5\t5\t5\n14\t6\t5\t5\n14\t7\t5\t6\n14\t8\t5\t5\n14\t1\t6\t3\n14\t2\t6\t7\n14\t3\t6\t6\n14\t4\t6\t5\n14\t5\t6\t3\n14\t6\t6\t5\n14\t7\t6\t5\n14\t8\t6\t5\n15\t1\t1\t5\n15\t2\t1\t6\n15\t3\t1\t8\n15\t4\t1\t7\n15\t5\t1\t7\n15\t6\t1\t8\n15\t7\t1\t6\n15\t8\t1\t6\n15\t1\t2\t4\n15\t2\t2\t4\n15\t3\t2\t9\n15\t4\t2\t7\n15\t5\t2\t5\n15\t6\t2\t8\n15\t7\t2\t6\n15\t8\t2\t6\n15\t1\t3\t4\n15\t2\t3\t6\n15\t3\t3\t6\n15\t4\t3\t6\n15\t5\t3\t4\n15\t6\t3\t5\n15\t7\t3\t6\n15\t8\t3\t4\n15\t1\t4\t4\n15\t2\t4\t4\n15\t3\t4\t7\n15\t4\t4\t6\n15\t5\t4\t4\n15\t6\t4\t5\n15\t7\t4\t6\n15\t8\t4\t5\n15\t1\t5\t4\n15\t2\t5\t4\n15\t3\t5\t6\n15\t4\t5\t7\n15\t5\t5\t3\n15\t6\t5\t5\n15\t7\t5\t6\n15\t8\t5\t5\n15\t1\t6\t4\n15\t2\t6\t5\n15\t3\t6\t6\n15\t4\t6\t6\n15\t5\t6\t5\n15\t6\t6\t5\n15\t7\t6\t5\n15\t8\t6\t5\n16\t1\t1\t5\n16\t2\t1\t3\n16\t3\t1\t7\n16\t4\t1\t6\n16\t5\t1\t7\n16\t6\t1\t7\n16\t7\t1\t6\n16\t8\t1\t3\n16\t1\t2\t5\n16\t2\t2\t3\n16\t3\t2\t7\n16\t4\t2\t6\n16\t5\t2\t5\n16\t6\t2\t7\n16\t7\t2\t6\n16\t8\t2\t3\n16\t1\t3\t4\n16\t2\t3\t4\n16\t3\t3\t8\n16\t4\t3\t6\n16\t5\t3\t6\n16\t6\t3\t5\n16\t7\t3\t6\n16\t8\t3\t3\n16\t1\t4\t4\n16\t2\t4\t4\n16\t3\t4\t7\n16\t4\t4\t6\n16\t5\t4\t6\n16\t6\t4\t5\n16\t7\t4\t6\n16\t8\t4\t3\n16\t1\t5\t3\n16\t2\t5\t4\n16\t3\t5\t8\n16\t4\t5\t6\n16\t5\t5\t6\n16\t6\t5\t6\n16\t7\t5\t6\n16\t8\t5\t4\n16\t1\t6\t3\n16\t2\t6\t4\n16\t3\t6\t6\n16\t4\t6\t6\n16\t5\t6\t5\n16\t6\t6\t5\n16\t7\t6\t5\n16\t8\t6\t4\n17\t1\t1\t6\n17\t2\t1\t6\n17\t3\t1\t8\n17\t4\t1\t7\n17\t5\t1\t7\n17\t6\t1\t7\n17\t7\t1\t6\n17\t8\t1\t8\n17\t1\t2\t5\n17\t2\t2\t6\n17\t3\t2\t8\n17\t4\t2\t7\n17\t5\t2\t6\n17\t6\t2\t7\n17\t7\t2\t6\n17\t8\t2\t5\n17\t1\t3\t4\n17\t2\t3\t6\n17\t3\t3\t7\n17\t4\t3\t7\n17\t5\t3\t7\n17\t6\t3\t6\n17\t7\t3\t6\n17\t8\t3\t5\n17\t1\t4\t4\n17\t2\t4\t6\n17\t3\t4\t7\n17\t4\t4\t7\n17\t5\t4\t7\n17\t6\t4\t5\n17\t7\t4\t6\n17\t8\t4\t5\n17\t1\t5\t4\n17\t2\t5\t7\n17\t3\t5\t7\n17\t4\t5\t7\n17\t5\t5\t5\n17\t6\t5\t6\n17\t7\t5\t6\n17\t8\t5\t5\n17\t1\t6\t3\n17\t2\t6\t7\n17\t3\t6\t6\n17\t4\t6\t7\n17\t5\t6\t5\n17\t6\t6\t5\n17\t7\t6\t5\n17\t8\t6\t5\n18\t1\t1\t7\n18\t2\t1\t4\n18\t3\t1\t7\n18\t4\t1\t7\n18\t5\t1\t6\n18\t6\t1\t7\n18\t7\t1\t7\n18\t8\t1\t4\n18\t1\t2\t5\n18\t2\t2\t5\n18\t3\t2\t7\n18\t4\t2\t7\n18\t5\t2\t5\n18\t6\t2\t7\n18\t7\t2\t6\n18\t8\t2\t4\n18\t1\t3\t4\n18\t2\t3\t4\n18\t3\t3\t6\n18\t4\t3\t7\n18\t5\t3\t5\n18\t6\t3\t6\n18\t7\t3\t6\n18\t8\t3\t4\n18\t1\t4\t4\n18\t2\t4\t3\n18\t3\t4\t7\n18\t4\t4\t7\n18\t5\t4\t5\n18\t6\t4\t6\n18\t7\t4\t6\n18\t8\t4\t4\n18\t1\t5\t4\n18\t2\t5\t4\n18\t3\t5\t6\n18\t4\t5\t7\n18\t5\t5\t5\n18\t6\t5\t6\n18\t7\t5\t6\n18\t8\t5\t4\n18\t1\t6\t3\n18\t2\t6\t4\n18\t3\t6\t6\n18\t4\t6\t7\n18\t5\t6\t5\n18\t6\t6\t5\n18\t7\t6\t5\n18\t8\t6\t4\n19\t1\t1\t6\n19\t2\t1\t3\n19\t3\t1\t7\n19\t4\t1\t6\n19\t5\t1\t6\n19\t6\t1\t7\n19\t7\t1\t6\n19\t8\t1\t3\n19\t1\t2\t4\n19\t2\t2\t3\n19\t3\t2\t7\n19\t4\t2\t6\n19\t5\t2\t4\n19\t6\t2\t7\n19\t7\t2\t6\n19\t8\t2\t3\n19\t1\t3\t4\n19\t2\t3\t3\n19\t3\t3\t6\n19\t4\t3\t6\n19\t5\t3\t4\n19\t6\t3\t5\n19\t7\t3\t6\n19\t8\t3\t4\n19\t1\t4\t3\n19\t2\t4\t4\n19\t3\t4\t6\n19\t4\t4\t6\n19\t5\t4\t4\n19\t6\t4\t5\n19\t7\t4\t5\n19\t8\t4\t4\n19\t1\t5\t4\n19\t2\t5\t4\n19\t3\t5\t6\n19\t4\t5\t6\n19\t5\t5\t3\n19\t6\t5\t5\n19\t7\t5\t6\n19\t8\t5\t5\n19\t1\t6\t3\n19\t2\t6\t3\n19\t3\t6\t6\n19\t4\t6\t6\n19\t5\t6\t5\n19\t6\t6\t5\n19\t7\t6\t5\n19\t8\t6\t5\n20\t1\t1\t7\n20\t2\t1\t3\n20\t3\t1\t7\n20\t4\t1\t7\n20\t5\t1\t7\n20\t6\t1\t7\n20\t7\t1\t7\n20\t8\t1\t5\n20\t1\t2\t5\n20\t2\t2\t3\n20\t3\t2\t7\n20\t4\t2\t7\n20\t5\t2\t6\n20\t6\t2\t7\n20\t7\t2\t6\n20\t8\t2\t5\n20\t1\t3\t5\n20\t2\t3\t3\n20\t3\t3\t8\n20\t4\t3\t7\n20\t5\t3\t4\n20\t6\t3\t7\n20\t7\t3\t6\n20\t8\t3\t4\n20\t1\t4\t5\n20\t2\t4\t3\n20\t3\t4\t8\n20\t4\t4\t7\n20\t5\t4\t4\n20\t6\t4\t7\n20\t7\t4\t6\n20\t8\t4\t4\n20\t1\t5\t4\n20\t2\t5\t3\n20\t3\t5\t7\n20\t4\t5\t7\n20\t5\t5\t3\n20\t6\t5\t7\n20\t7\t5\t6\n20\t8\t5\t5\n20\t1\t6\t4\n20\t2\t6\t4\n20\t3\t6\t6\n20\t4\t6\t7\n20\t5\t6\t4\n20\t6\t6\t5\n20\t7\t6\t5\n20\t8\t6\t5",
                mode="r", theme="cobalt"),

            br(),

            h3("Variance components"),

            verbatimTextOutput("var.est.out"),

            br(),

            h3("G-coefficient"),
            verbatimTextOutput("g.coef.out"),

            br(),

            h3("Phi"),
            verbatimTextOutput("phi.out"),

            br(),

            h3("D study"),

            # Display this only if "pri" is checked
            conditionalPanel(condition = "input.type == 'pri'",
                numericInput("n.raters", "Number of raters", 3)
            ),

            numericInput("n.items", "Number of items", 5),

            verbatimTextOutput("D.out"),

            plotOutput("Plot", height = "550px"),

            br(),
            br(),


            strong('R session info'),
            verbatimTextOutput("info.out")
            ),





    tabPanel("Input Examples",

        p('Note: Input values must be separated by tabs. Copy and paste from Excel/Numbers.'),

        p(HTML("<b><div style='background-color:#FADDF2;border:1px solid black;'>Your data needs to have exactly the same header (variable names) in the first row.</div></b>")),

        br(),

        p(strong("p × i Design")),
        aceEditor("text1", value="ID\ti01\ti02\ti03\ti04\ti05\ti06\ti07\ti08\ti09\ti10\ti11\ti12\ti13\ti14\ti15\ti16\ti17\ti18\ti19\ti20\ti21\ti22\ti23\ti24\ti25\ti26\ti27\ti28\ti29\ti30\n33\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\n3\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\n39\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t0\t1\t1\t1\t0\t1\t1\t1\t1\n15\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t0\t1\t1\t1\t1\t1\t1\n5\t1\t1\t0\t0\t1\t0\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\n9\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\n2\t1\t1\t0\t0\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\n40\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t0\t1\t1\t1\n31\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t0\t0\t0\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\n16\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t1\t0\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\n12\t1\t1\t1\t0\t1\t1\t1\t0\t1\t0\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\n25\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t0\t0\t1\t1\t1\t1\t0\t1\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t1\t1\n42\t1\t1\t0\t1\t1\t0\t1\t1\t1\t0\t0\t1\t0\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\n38\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t0\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t0\t1\t1\t0\t0\n22\t1\t1\t1\t1\t1\t0\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t0\t1\t1\t0\t1\n10\t1\t1\t0\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t0\t1\t1\t1\t0\t0\t1\t1\n18\t1\t1\t1\t0\t1\t1\t1\t0\t1\t1\t0\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t0\n32\t1\t1\t1\t0\t1\t0\t1\t0\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t0\t1\t1\t0\t1\t1\t1\n13\t1\t1\t0\t1\t1\t0\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t1\t1\t0\t1\t0\t1\n41\t1\t1\t1\t1\t0\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t0\t1\t0\t1\t0\t0\t1\t1\t1\n8\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t0\t1\t1\t1\t1\t0\t1\t1\t0\t1\t1\t0\t1\n1\t0\t1\t1\t0\t1\t1\t1\t0\t1\t0\t0\t0\t1\t1\t1\t1\t0\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\n11\t0\t1\t1\t0\t0\t0\t0\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t1\t1\t0\t1\t1\t1\n26\t1\t0\t1\t0\t1\t0\t1\t1\t1\t1\t0\t0\t1\t1\t1\t1\t0\t1\t1\t1\t0\t0\t0\t1\t1\t1\t1\t1\t1\t1\n30\t1\t1\t1\t1\t1\t1\t0\t1\t0\t1\t0\t0\t1\t1\t1\t1\t0\t1\t0\t1\t1\t1\t1\t1\t0\t0\t0\t1\t1\t1\n14\t1\t1\t0\t0\t0\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t1\t0\t1\t1\t1\t1\t0\t1\t0\t0\t1\t1\t1\t1\t1\n34\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t1\t1\t0\t1\t1\t1\t0\t1\t1\t1\t1\t0\t0\t1\t1\t1\t0\t1\t0\t0\n35\t1\t1\t1\t1\t1\t0\t1\t1\t1\t0\t0\t1\t0\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t0\t0\t1\t1\t0\n27\t0\t1\t0\t0\t1\t1\t1\t1\t0\t0\t0\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\n24\t0\t1\t1\t0\t0\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t0\t1\t0\t1\t1\t0\n7\t0\t1\t0\t0\t1\t1\t1\t1\t1\t1\t0\t1\t0\t1\t1\t0\t1\t1\t1\t1\t0\t0\t0\t1\t1\t1\t0\t1\t1\t1\n6\t1\t0\t1\t0\t0\t1\t1\t0\t1\t0\t0\t1\t0\t1\t0\t1\t1\t1\t1\t1\t1\t0\t0\t1\t1\t1\t0\t1\t1\t1\n29\t0\t1\t0\t0\t0\t1\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t0\t1\t1\t0\t1\t1\t1\t0\t1\t0\t0\t1\t1\t1\n17\t0\t1\t1\t1\t0\t1\t1\t0\t1\t0\t1\t1\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t0\t1\t1\t0\t0\t0\t0\t0\n20\t0\t1\t0\t0\t1\t0\t1\t1\t1\t0\t0\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\t0\t0\t0\t0\t1\t0\t1\t1\t0\n23\t1\t1\t1\t1\t1\t1\t0\t1\t1\t1\t1\t1\t0\t0\t0\t0\t1\t0\t1\t1\t0\t0\t0\t0\t0\t0\t0\t1\t1\t1\n36\t0\t0\t0\t0\t0\t1\t1\t1\t1\t0\t1\t1\t0\t1\t0\t1\t0\t1\t1\t1\t1\t0\t0\t0\t0\t1\t0\t1\t1\t1\n37\t0\t0\t0\t0\t0\t1\t1\t1\t1\t0\t1\t1\t0\t1\t0\t1\t0\t1\t1\t1\t1\t0\t0\t0\t0\t1\t0\t1\t1\t1\n4\t0\t1\t0\t0\t0\t1\t1\t1\t0\t0\t0\t1\t0\t1\t1\t1\t1\t0\t1\t1\t0\t0\t0\t0\t0\t1\t1\t0\t1\t1\n19\t1\t1\t0\t0\t0\t0\t1\t1\t1\t0\t1\t1\t0\t1\t1\t1\t0\t1\t1\t1\t0\t0\t0\t0\t0\t0\t0\t0\t1\t0\n21\t0\t1\t0\t0\t1\t0\t0\t0\t1\t0\t0\t0\t1\t0\t0\t0\t1\t0\t0\t0\t0\t0\t1\t0\t0\t0\t0\t0\t1\t0\n28\t1\t0\t0\t0\t0\t0\t0\t1\t0\t0\t1\t0\t0\t0\t1\t0\t0\t1\t0\t0\t0\t1\t0\t0\t0\t0\t0\t0\t0\t1", mode="r", theme="solarized_light"),


        br(),
        p(strong("p × r × i Design")),
        aceEditor("text2", value="Student\tRater\tItem\tScore\n1\t1\t1\t5\n1\t2\t1\t2\n1\t3\t1\t7\n1\t4\t1\t6\n1\t5\t1\t6\n1\t6\t1\t6\n1\t7\t1\t5\n1\t8\t1\t2\n1\t1\t2\t4\n1\t2\t2\t2\n1\t3\t2\t6\n1\t4\t2\t6\n1\t5\t2\t3\n1\t6\t2\t6\n1\t7\t2\t5\n1\t8\t2\t2\n1\t1\t3\t3\n1\t2\t3\t3\n1\t3\t3\t7\n1\t4\t3\t6\n1\t5\t3\t5\n1\t6\t3\t7\n1\t7\t3\t6\n1\t8\t3\t3\n1\t1\t4\t3\n1\t2\t4\t2\n1\t3\t4\t7\n1\t4\t4\t6\n1\t5\t4\t5\n1\t6\t4\t7\n1\t7\t4\t6\n1\t8\t4\t3\n1\t1\t5\t4\n1\t2\t5\t3\n1\t3\t5\t7\n1\t4\t5\t6\n1\t5\t5\t5\n1\t6\t5\t7\n1\t7\t5\t6\n1\t8\t5\t3\n1\t1\t6\t3\n1\t2\t6\t3\n1\t3\t6\t6\n1\t4\t6\t6\n1\t5\t6\t5\n1\t6\t6\t5\n1\t7\t6\t5\n1\t8\t6\t3\n2\t1\t1\t5\n2\t2\t1\t3\n2\t3\t1\t7\n2\t4\t1\t7\n2\t5\t1\t6\n2\t6\t1\t7\n2\t7\t1\t6\n2\t8\t1\t4\n2\t1\t2\t5\n2\t2\t2\t3\n2\t3\t2\t7\n2\t4\t2\t7\n2\t5\t2\t5\n2\t6\t2\t7\n2\t7\t2\t6\n2\t8\t2\t4\n2\t1\t3\t4\n2\t2\t3\t3\n2\t3\t3\t7\n2\t4\t3\t7\n2\t5\t3\t5\n2\t6\t3\t6\n2\t7\t3\t6\n2\t8\t3\t3\n2\t1\t4\t4\n2\t2\t4\t3\n2\t3\t4\t7\n2\t4\t4\t7\n2\t5\t4\t5\n2\t6\t4\t6\n2\t7\t4\t6\n2\t8\t4\t3\n2\t1\t5\t3\n2\t2\t5\t4\n2\t3\t5\t7\n2\t4\t5\t7\n2\t5\t5\t5\n2\t6\t5\t6\n2\t7\t5\t6\n2\t8\t5\t3\n2\t1\t6\t4\n2\t2\t6\t3\n2\t3\t6\t6\n2\t4\t6\t7\n2\t5\t6\t5\n2\t6\t6\t5\n2\t7\t6\t5\n2\t8\t6\t3\n3\t1\t1\t5\n3\t2\t1\t2\n3\t3\t1\t7\n3\t4\t1\t5\n3\t5\t1\t6\n3\t6\t1\t6\n3\t7\t1\t5\n3\t8\t1\t2\n3\t1\t2\t3\n3\t2\t2\t2\n3\t3\t2\t7\n3\t4\t2\t5\n3\t5\t2\t4\n3\t6\t2\t6\n3\t7\t2\t5\n3\t8\t2\t2\n3\t1\t3\t3\n3\t2\t3\t2\n3\t3\t3\t7\n3\t4\t3\t5\n3\t5\t3\t5\n3\t6\t3\t6\n3\t7\t3\t6\n3\t8\t3\t4\n3\t1\t4\t4\n3\t2\t4\t3\n3\t3\t4\t7\n3\t4\t4\t5\n3\t5\t4\t4\n3\t6\t4\t6\n3\t7\t4\t6\n3\t8\t4\t4\n3\t1\t5\t4\n3\t2\t5\t3\n3\t3\t5\t8\n3\t4\t5\t6\n3\t5\t5\t4\n3\t6\t5\t6\n3\t7\t5\t6\n3\t8\t5\t4\n3\t1\t6\t4\n3\t2\t6\t3\n3\t3\t6\t6\n3\t4\t6\t6\n3\t5\t6\t5\n3\t6\t6\t5\n3\t7\t6\t5\n3\t8\t6\t2\n4\t1\t1\t6\n4\t2\t1\t4\n4\t3\t1\t8\n4\t4\t1\t6\n4\t5\t1\t7\n4\t6\t1\t7\n4\t7\t1\t7\n4\t8\t1\t3\n4\t1\t2\t4\n4\t2\t2\t5\n4\t3\t2\t7\n4\t4\t2\t6\n4\t5\t2\t5\n4\t6\t2\t7\n4\t7\t2\t6\n4\t8\t2\t3\n4\t1\t3\t4\n4\t2\t3\t6\n4\t3\t3\t8\n4\t4\t3\t6\n4\t5\t3\t5\n4\t6\t3\t5\n4\t7\t3\t6\n4\t8\t3\t2\n4\t1\t4\t5\n4\t2\t4\t6\n4\t3\t4\t8\n4\t4\t4\t6\n4\t5\t4\t5\n4\t6\t4\t6\n4\t7\t4\t6\n4\t8\t4\t2\n4\t1\t5\t4\n4\t2\t5\t6\n4\t3\t5\t8\n4\t4\t5\t7\n4\t5\t5\t5\n4\t6\t5\t5\n4\t7\t5\t6\n4\t8\t5\t2\n4\t1\t6\t4\n4\t2\t6\t6\n4\t3\t6\t6\n4\t4\t6\t6\n4\t5\t6\t5\n4\t6\t6\t5\n4\t7\t6\t5\n4\t8\t6\t3\n5\t1\t1\t5\n5\t2\t1\t3\n5\t3\t1\t5\n5\t4\t1\t5\n5\t5\t1\t4\n5\t6\t1\t7\n5\t7\t1\t5\n5\t8\t1\t1\n5\t1\t2\t4\n5\t2\t2\t3\n5\t3\t2\t7\n5\t4\t2\t5\n5\t5\t2\t4\n5\t6\t2\t6\n5\t7\t2\t5\n5\t8\t2\t1\n5\t1\t3\t3\n5\t2\t3\t4\n5\t3\t3\t7\n5\t4\t3\t5\n5\t5\t3\t2\n5\t6\t3\t6\n5\t7\t3\t6\n5\t8\t3\t2\n5\t1\t4\t3\n5\t2\t4\t4\n5\t3\t4\t6\n5\t4\t4\t5\n5\t5\t4\t2\n5\t6\t4\t6\n5\t7\t4\t6\n5\t8\t4\t2\n5\t1\t5\t3\n5\t2\t5\t4\n5\t3\t5\t7\n5\t4\t5\t5\n5\t5\t5\t2\n5\t6\t5\t6\n5\t7\t5\t6\n5\t8\t5\t1\n5\t1\t6\t3\n5\t2\t6\t4\n5\t3\t6\t6\n5\t4\t6\t5\n5\t5\t6\t3\n5\t6\t6\t5\n5\t7\t6\t5\n5\t8\t6\t1\n6\t1\t1\t5\n6\t2\t1\t5\n6\t3\t1\t8\n6\t4\t1\t6\n6\t5\t1\t7\n6\t6\t1\t7\n6\t7\t1\t7\n6\t8\t1\t4\n6\t1\t2\t4\n6\t2\t2\t4\n6\t3\t2\t8\n6\t4\t2\t6\n6\t5\t2\t5\n6\t6\t2\t7\n6\t7\t2\t6\n6\t8\t2\t4\n6\t1\t3\t3\n6\t2\t3\t3\n6\t3\t3\t7\n6\t4\t3\t6\n6\t5\t3\t4\n6\t6\t3\t5\n6\t7\t3\t6\n6\t8\t3\t4\n6\t1\t4\t4\n6\t2\t4\t4\n6\t3\t4\t7\n6\t4\t4\t6\n6\t5\t4\t4\n6\t6\t4\t6\n6\t7\t4\t6\n6\t8\t4\t4\n6\t1\t5\t3\n6\t2\t5\t4\n6\t3\t5\t8\n6\t4\t5\t6\n6\t5\t5\t5\n6\t6\t5\t5\n6\t7\t5\t6\n6\t8\t5\t4\n6\t1\t6\t4\n6\t2\t6\t4\n6\t3\t6\t6\n6\t4\t6\t6\n6\t5\t6\t5\n6\t6\t6\t5\n6\t7\t6\t5\n6\t8\t6\t4\n7\t1\t1\t6\n7\t2\t1\t6\n7\t3\t1\t7\n7\t4\t1\t5\n7\t5\t1\t6\n7\t6\t1\t7\n7\t7\t1\t7\n7\t8\t1\t3\n7\t1\t2\t5\n7\t2\t2\t5\n7\t3\t2\t6\n7\t4\t2\t5\n7\t5\t2\t4\n7\t6\t2\t7\n7\t7\t2\t6\n7\t8\t2\t4\n7\t1\t3\t4\n7\t2\t3\t6\n7\t3\t3\t6\n7\t4\t3\t5\n7\t5\t3\t4\n7\t6\t3\t6\n7\t7\t3\t6\n7\t8\t3\t3\n7\t1\t4\t4\n7\t2\t4\t6\n7\t3\t4\t6\n7\t4\t4\t5\n7\t5\t4\t4\n7\t6\t4\t6\n7\t7\t4\t6\n7\t8\t4\t3\n7\t1\t5\t4\n7\t2\t5\t6\n7\t3\t5\t6\n7\t4\t5\t5\n7\t5\t5\t5\n7\t6\t5\t6\n7\t7\t5\t6\n7\t8\t5\t4\n7\t1\t6\t4\n7\t2\t6\t6\n7\t3\t6\t6\n7\t4\t6\t5\n7\t5\t6\t4\n7\t6\t6\t5\n7\t7\t6\t5\n7\t8\t6\t3\n8\t1\t1\t6\n8\t2\t1\t3\n8\t3\t1\t7\n8\t4\t1\t7\n8\t5\t1\t7\n8\t6\t1\t7\n8\t7\t1\t7\n8\t8\t1\t5\n8\t1\t2\t5\n8\t2\t2\t3\n8\t3\t2\t7\n8\t4\t2\t7\n8\t5\t2\t5\n8\t6\t2\t7\n8\t7\t2\t5\n8\t8\t2\t5\n8\t1\t3\t3\n8\t2\t3\t3\n8\t3\t3\t6\n8\t4\t3\t6\n8\t5\t3\t4\n8\t6\t3\t6\n8\t7\t3\t5\n8\t8\t3\t4\n8\t1\t4\t3\n8\t2\t4\t4\n8\t3\t4\t7\n8\t4\t4\t6\n8\t5\t4\t4\n8\t6\t4\t6\n8\t7\t4\t6\n8\t8\t4\t5\n8\t1\t5\t4\n8\t2\t5\t3\n8\t3\t5\t6\n8\t4\t5\t7\n8\t5\t5\t4\n8\t6\t5\t5\n8\t7\t5\t7\n8\t8\t5\t5\n8\t1\t6\t4\n8\t2\t6\t4\n8\t3\t6\t6\n8\t4\t6\t6\n8\t5\t6\t4\n8\t6\t6\t5\n8\t7\t6\t5\n8\t8\t6\t5\n9\t1\t1\t6\n9\t2\t1\t4\n9\t3\t1\t8\n9\t4\t1\t6\n9\t5\t1\t7\n9\t6\t1\t8\n9\t7\t1\t7\n9\t8\t1\t6\n9\t1\t2\t5\n9\t2\t2\t4\n9\t3\t2\t8\n9\t4\t2\t6\n9\t5\t2\t7\n9\t6\t2\t8\n9\t7\t2\t7\n9\t8\t2\t6\n9\t1\t3\t4\n9\t2\t3\t3\n9\t3\t3\t6\n9\t4\t3\t5\n9\t5\t3\t5\n9\t6\t3\t5\n9\t7\t3\t6\n9\t8\t3\t4\n9\t1\t4\t3\n9\t2\t4\t3\n9\t3\t4\t6\n9\t4\t4\t5\n9\t5\t4\t5\n9\t6\t4\t6\n9\t7\t4\t6\n9\t8\t4\t4\n9\t1\t5\t4\n9\t2\t5\t3\n9\t3\t5\t6\n9\t4\t5\t5\n9\t5\t5\t5\n9\t6\t5\t5\n9\t7\t5\t6\n9\t8\t5\t4\n9\t1\t6\t4\n9\t2\t6\t3\n9\t3\t6\t6\n9\t4\t6\t5\n9\t5\t6\t5\n9\t6\t6\t5\n9\t7\t6\t5\n9\t8\t6\t4\n10\t1\t1\t6\n10\t2\t1\t6\n10\t3\t1\t8\n10\t4\t1\t7\n10\t5\t1\t7\n10\t6\t1\t7\n10\t7\t1\t7\n10\t8\t1\t5\n10\t1\t2\t5\n10\t2\t2\t6\n10\t3\t2\t9\n10\t4\t2\t7\n10\t5\t2\t7\n10\t6\t2\t7\n10\t7\t2\t7\n10\t8\t2\t5\n10\t1\t3\t5\n10\t2\t3\t7\n10\t3\t3\t8\n10\t4\t3\t7\n10\t5\t3\t5\n10\t6\t3\t5\n10\t7\t3\t6\n10\t8\t3\t5\n10\t1\t4\t4\n10\t2\t4\t7\n10\t3\t4\t8\n10\t4\t4\t7\n10\t5\t4\t5\n10\t6\t4\t6\n10\t7\t4\t6\n10\t8\t4\t5\n10\t1\t5\t4\n10\t2\t5\t7\n10\t3\t5\t8\n10\t4\t5\t7\n10\t5\t5\t5\n10\t6\t5\t5\n10\t7\t5\t6\n10\t8\t5\t4\n10\t1\t6\t4\n10\t2\t6\t7\n10\t3\t6\t6\n10\t4\t6\t7\n10\t5\t6\t5\n10\t6\t6\t5\n10\t7\t6\t5\n10\t8\t6\t4\n11\t1\t1\t6\n11\t2\t1\t7\n11\t3\t1\t7\n11\t4\t1\t6\n11\t5\t1\t7\n11\t6\t1\t7\n11\t7\t1\t7\n11\t8\t1\t4\n11\t1\t2\t5\n11\t2\t2\t6\n11\t3\t2\t7\n11\t4\t2\t6\n11\t5\t2\t7\n11\t6\t2\t7\n11\t7\t2\t7\n11\t8\t2\t4\n11\t1\t3\t4\n11\t2\t3\t6\n11\t3\t3\t7\n11\t4\t3\t5\n11\t5\t3\t5\n11\t6\t3\t6\n11\t7\t3\t7\n11\t8\t3\t5\n11\t1\t4\t4\n11\t2\t4\t6\n11\t3\t4\t7\n11\t4\t4\t5\n11\t5\t4\t5\n11\t6\t4\t6\n11\t7\t4\t6\n11\t8\t4\t5\n11\t1\t5\t3\n11\t2\t5\t5\n11\t3\t5\t7\n11\t4\t5\t5\n11\t5\t5\t5\n11\t6\t5\t5\n11\t7\t5\t6\n11\t8\t5\t5\n11\t1\t6\t4\n11\t2\t6\t5\n11\t3\t6\t6\n11\t4\t6\t5\n11\t5\t6\t6\n11\t6\t6\t5\n11\t7\t6\t5\n11\t8\t6\t5\n12\t1\t1\t6\n12\t2\t1\t6\n12\t3\t1\t7\n12\t4\t1\t6\n12\t5\t1\t7\n12\t6\t1\t7\n12\t7\t1\t7\n12\t8\t1\t4\n12\t1\t2\t5\n12\t2\t2\t5\n12\t3\t2\t8\n12\t4\t2\t6\n12\t5\t2\t7\n12\t6\t2\t7\n12\t7\t2\t6\n12\t8\t2\t4\n12\t1\t3\t4\n12\t2\t3\t6\n12\t3\t3\t8\n12\t4\t3\t6\n12\t5\t3\t4\n12\t6\t3\t5\n12\t7\t3\t6\n12\t8\t3\t4\n12\t1\t4\t3\n12\t2\t4\t6\n12\t3\t4\t8\n12\t4\t4\t6\n12\t5\t4\t4\n12\t6\t4\t6\n12\t7\t4\t6\n12\t8\t4\t5\n12\t1\t5\t3\n12\t2\t5\t6\n12\t3\t5\t7\n12\t4\t5\t6\n12\t5\t5\t4\n12\t6\t5\t5\n12\t7\t5\t6\n12\t8\t5\t5\n12\t1\t6\t3\n12\t2\t6\t6\n12\t3\t6\t6\n12\t4\t6\t6\n12\t5\t6\t6\n12\t6\t6\t5\n12\t7\t6\t5\n12\t8\t6\t4\n13\t1\t1\t6\n13\t2\t1\t6\n13\t3\t1\t7\n13\t4\t1\t7\n13\t5\t1\t7\n13\t6\t1\t7\n13\t7\t1\t7\n13\t8\t1\t5\n13\t1\t2\t5\n13\t2\t2\t6\n13\t3\t2\t7\n13\t4\t2\t7\n13\t5\t2\t5\n13\t6\t2\t7\n13\t7\t2\t6\n13\t8\t2\t5\n13\t1\t3\t4\n13\t2\t3\t7\n13\t3\t3\t6\n13\t4\t3\t7\n13\t5\t3\t4\n13\t6\t3\t6\n13\t7\t3\t6\n13\t8\t3\t5\n13\t1\t4\t3\n13\t2\t4\t7\n13\t3\t4\t7\n13\t4\t4\t7\n13\t5\t4\t4\n13\t6\t4\t6\n13\t7\t4\t6\n13\t8\t4\t5\n13\t1\t5\t3\n13\t2\t5\t7\n13\t3\t5\t6\n13\t4\t5\t7\n13\t5\t5\t4\n13\t6\t5\t5\n13\t7\t5\t6\n13\t8\t5\t4\n13\t1\t6\t4\n13\t2\t6\t7\n13\t3\t6\t6\n13\t4\t6\t7\n13\t5\t6\t4\n13\t6\t6\t5\n13\t7\t6\t5\n13\t8\t6\t4\n14\t1\t1\t7\n14\t2\t1\t6\n14\t3\t1\t7\n14\t4\t1\t5\n14\t5\t1\t7\n14\t6\t1\t7\n14\t7\t1\t6\n14\t8\t1\t6\n14\t1\t2\t5\n14\t2\t2\t6\n14\t3\t2\t7\n14\t4\t2\t5\n14\t5\t2\t7\n14\t6\t2\t7\n14\t7\t2\t6\n14\t8\t2\t5\n14\t1\t3\t5\n14\t2\t3\t7\n14\t3\t3\t7\n14\t4\t3\t5\n14\t5\t3\t5\n14\t6\t3\t6\n14\t7\t3\t6\n14\t8\t3\t5\n14\t1\t4\t4\n14\t2\t4\t7\n14\t3\t4\t5\n14\t4\t4\t5\n14\t5\t4\t5\n14\t6\t4\t6\n14\t7\t4\t6\n14\t8\t4\t5\n14\t1\t5\t3\n14\t2\t5\t7\n14\t3\t5\t7\n14\t4\t5\t5\n14\t5\t5\t5\n14\t6\t5\t5\n14\t7\t5\t6\n14\t8\t5\t5\n14\t1\t6\t3\n14\t2\t6\t7\n14\t3\t6\t6\n14\t4\t6\t5\n14\t5\t6\t3\n14\t6\t6\t5\n14\t7\t6\t5\n14\t8\t6\t5\n15\t1\t1\t5\n15\t2\t1\t6\n15\t3\t1\t8\n15\t4\t1\t7\n15\t5\t1\t7\n15\t6\t1\t8\n15\t7\t1\t6\n15\t8\t1\t6\n15\t1\t2\t4\n15\t2\t2\t4\n15\t3\t2\t9\n15\t4\t2\t7\n15\t5\t2\t5\n15\t6\t2\t8\n15\t7\t2\t6\n15\t8\t2\t6\n15\t1\t3\t4\n15\t2\t3\t6\n15\t3\t3\t6\n15\t4\t3\t6\n15\t5\t3\t4\n15\t6\t3\t5\n15\t7\t3\t6\n15\t8\t3\t4\n15\t1\t4\t4\n15\t2\t4\t4\n15\t3\t4\t7\n15\t4\t4\t6\n15\t5\t4\t4\n15\t6\t4\t5\n15\t7\t4\t6\n15\t8\t4\t5\n15\t1\t5\t4\n15\t2\t5\t4\n15\t3\t5\t6\n15\t4\t5\t7\n15\t5\t5\t3\n15\t6\t5\t5\n15\t7\t5\t6\n15\t8\t5\t5\n15\t1\t6\t4\n15\t2\t6\t5\n15\t3\t6\t6\n15\t4\t6\t6\n15\t5\t6\t5\n15\t6\t6\t5\n15\t7\t6\t5\n15\t8\t6\t5\n16\t1\t1\t5\n16\t2\t1\t3\n16\t3\t1\t7\n16\t4\t1\t6\n16\t5\t1\t7\n16\t6\t1\t7\n16\t7\t1\t6\n16\t8\t1\t3\n16\t1\t2\t5\n16\t2\t2\t3\n16\t3\t2\t7\n16\t4\t2\t6\n16\t5\t2\t5\n16\t6\t2\t7\n16\t7\t2\t6\n16\t8\t2\t3\n16\t1\t3\t4\n16\t2\t3\t4\n16\t3\t3\t8\n16\t4\t3\t6\n16\t5\t3\t6\n16\t6\t3\t5\n16\t7\t3\t6\n16\t8\t3\t3\n16\t1\t4\t4\n16\t2\t4\t4\n16\t3\t4\t7\n16\t4\t4\t6\n16\t5\t4\t6\n16\t6\t4\t5\n16\t7\t4\t6\n16\t8\t4\t3\n16\t1\t5\t3\n16\t2\t5\t4\n16\t3\t5\t8\n16\t4\t5\t6\n16\t5\t5\t6\n16\t6\t5\t6\n16\t7\t5\t6\n16\t8\t5\t4\n16\t1\t6\t3\n16\t2\t6\t4\n16\t3\t6\t6\n16\t4\t6\t6\n16\t5\t6\t5\n16\t6\t6\t5\n16\t7\t6\t5\n16\t8\t6\t4\n17\t1\t1\t6\n17\t2\t1\t6\n17\t3\t1\t8\n17\t4\t1\t7\n17\t5\t1\t7\n17\t6\t1\t7\n17\t7\t1\t6\n17\t8\t1\t8\n17\t1\t2\t5\n17\t2\t2\t6\n17\t3\t2\t8\n17\t4\t2\t7\n17\t5\t2\t6\n17\t6\t2\t7\n17\t7\t2\t6\n17\t8\t2\t5\n17\t1\t3\t4\n17\t2\t3\t6\n17\t3\t3\t7\n17\t4\t3\t7\n17\t5\t3\t7\n17\t6\t3\t6\n17\t7\t3\t6\n17\t8\t3\t5\n17\t1\t4\t4\n17\t2\t4\t6\n17\t3\t4\t7\n17\t4\t4\t7\n17\t5\t4\t7\n17\t6\t4\t5\n17\t7\t4\t6\n17\t8\t4\t5\n17\t1\t5\t4\n17\t2\t5\t7\n17\t3\t5\t7\n17\t4\t5\t7\n17\t5\t5\t5\n17\t6\t5\t6\n17\t7\t5\t6\n17\t8\t5\t5\n17\t1\t6\t3\n17\t2\t6\t7\n17\t3\t6\t6\n17\t4\t6\t7\n17\t5\t6\t5\n17\t6\t6\t5\n17\t7\t6\t5\n17\t8\t6\t5\n18\t1\t1\t7\n18\t2\t1\t4\n18\t3\t1\t7\n18\t4\t1\t7\n18\t5\t1\t6\n18\t6\t1\t7\n18\t7\t1\t7\n18\t8\t1\t4\n18\t1\t2\t5\n18\t2\t2\t5\n18\t3\t2\t7\n18\t4\t2\t7\n18\t5\t2\t5\n18\t6\t2\t7\n18\t7\t2\t6\n18\t8\t2\t4\n18\t1\t3\t4\n18\t2\t3\t4\n18\t3\t3\t6\n18\t4\t3\t7\n18\t5\t3\t5\n18\t6\t3\t6\n18\t7\t3\t6\n18\t8\t3\t4\n18\t1\t4\t4\n18\t2\t4\t3\n18\t3\t4\t7\n18\t4\t4\t7\n18\t5\t4\t5\n18\t6\t4\t6\n18\t7\t4\t6\n18\t8\t4\t4\n18\t1\t5\t4\n18\t2\t5\t4\n18\t3\t5\t6\n18\t4\t5\t7\n18\t5\t5\t5\n18\t6\t5\t6\n18\t7\t5\t6\n18\t8\t5\t4\n18\t1\t6\t3\n18\t2\t6\t4\n18\t3\t6\t6\n18\t4\t6\t7\n18\t5\t6\t5\n18\t6\t6\t5\n18\t7\t6\t5\n18\t8\t6\t4\n19\t1\t1\t6\n19\t2\t1\t3\n19\t3\t1\t7\n19\t4\t1\t6\n19\t5\t1\t6\n19\t6\t1\t7\n19\t7\t1\t6\n19\t8\t1\t3\n19\t1\t2\t4\n19\t2\t2\t3\n19\t3\t2\t7\n19\t4\t2\t6\n19\t5\t2\t4\n19\t6\t2\t7\n19\t7\t2\t6\n19\t8\t2\t3\n19\t1\t3\t4\n19\t2\t3\t3\n19\t3\t3\t6\n19\t4\t3\t6\n19\t5\t3\t4\n19\t6\t3\t5\n19\t7\t3\t6\n19\t8\t3\t4\n19\t1\t4\t3\n19\t2\t4\t4\n19\t3\t4\t6\n19\t4\t4\t6\n19\t5\t4\t4\n19\t6\t4\t5\n19\t7\t4\t5\n19\t8\t4\t4\n19\t1\t5\t4\n19\t2\t5\t4\n19\t3\t5\t6\n19\t4\t5\t6\n19\t5\t5\t3\n19\t6\t5\t5\n19\t7\t5\t6\n19\t8\t5\t5\n19\t1\t6\t3\n19\t2\t6\t3\n19\t3\t6\t6\n19\t4\t6\t6\n19\t5\t6\t5\n19\t6\t6\t5\n19\t7\t6\t5\n19\t8\t6\t5\n20\t1\t1\t7\n20\t2\t1\t3\n20\t3\t1\t7\n20\t4\t1\t7\n20\t5\t1\t7\n20\t6\t1\t7\n20\t7\t1\t7\n20\t8\t1\t5\n20\t1\t2\t5\n20\t2\t2\t3\n20\t3\t2\t7\n20\t4\t2\t7\n20\t5\t2\t6\n20\t6\t2\t7\n20\t7\t2\t6\n20\t8\t2\t5\n20\t1\t3\t5\n20\t2\t3\t3\n20\t3\t3\t8\n20\t4\t3\t7\n20\t5\t3\t4\n20\t6\t3\t7\n20\t7\t3\t6\n20\t8\t3\t4\n20\t1\t4\t5\n20\t2\t4\t3\n20\t3\t4\t8\n20\t4\t4\t7\n20\t5\t4\t4\n20\t6\t4\t7\n20\t7\t4\t6\n20\t8\t4\t4\n20\t1\t5\t4\n20\t2\t5\t3\n20\t3\t5\t7\n20\t4\t5\t7\n20\t5\t5\t3\n20\t6\t5\t7\n20\t7\t5\t6\n20\t8\t5\t5\n20\t1\t6\t4\n20\t2\t6\t4\n20\t3\t6\t6\n20\t4\t6\t7\n20\t5\t6\t4\n20\t6\t6\t5\n20\t7\t6\t5\n20\t8\t6\t5", mode="r", theme="solarized_light"),


        br()

        ),





        tabPanel("About",

            strong('Note'),
            p('This web application is developed with',
            a("Shiny.", href="http://www.rstudio.com/shiny/", target="_blank"),
            ''),

            br(),

            strong('List of Packages Used'), br(),
            code('library(shiny)'),br(),
            code('library(shinyAce)'),br(),
            code('library(lme4)'),br(),

            br(),

            strong('Code'),
            p('Source code for this application is based on',
            a('"The handbook of Research in Foreign Language Learning and Teaching" (Takeuchi & Mizumoto, 2012)', href='http://mizumot.com/handbook/', target="_blank"), 'and',
            a("MacR.", href="https://sites.google.com/site/casualmacr/", target="_blank")),

            p('The code for this web application is available at',
            a('GitHub.', href='https://github.com/mizumot/g-theory', target="_blank")),

            p('If you want to run this code on your computer (in a local R session), run the code below:',
            br(),
            code('library(shiny)'),br(),
            code('runGitHub("g-theory","mizumot")')
            ),

            br(),

            strong('Recommended'),
            p('To learn more about R, I suggest this excellent and free e-book (pdf),',
            a("A Guide to Doing Statistics in Second Language Research Using R,", href="http://cw.routledge.com/textbooks/9780805861853/guide-to-R.asp", target="_blank"),
            'written by Dr. Jenifer Larson-Hall.'),

            p('Also, if you are a cool Mac user and want to use R with GUI,',
            a("MacR", href="https://sites.google.com/site/casualmacr/", target="_blank"),
            'is defenitely the way to go!'),

            br(),

            strong('Author'),
            p(a("Atsushi MIZUMOTO,", href="http://mizumot.com", target="_blank"),' Ph.D.',br(),
            'Associate Professor of Applied Linguistics',br(),
            'Faculty of Foreign Language Studies /',br(),
            'Graduate School of Foreign Language Education and Research,',br(),
            'Kansai University, Osaka, Japan'),

            br(),

            a(img(src="http://i.creativecommons.org/p/mark/1.0/80x15.png"), target="_blank", href="http://creativecommons.org/publicdomain/mark/1.0/"),

            p(br())

    )
)
)
))
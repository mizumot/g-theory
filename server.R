library(shiny)
library(shinyAce)
library(lme4)




shinyServer(function(input, output) {

################################################
# To be used later
################################################

    mod <- reactive({
    
        dat <- read.csv(text=input$text, sep="\t")
        
        
        if (input$type == "pi") {
        
        dat$Student <- factor(rownames(dat)) # id番号付与
        col.n <- length(dat)-1
        dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction = "long")
        dat <- dat[,-1]
        colnames(dat) <- c("Student", "Item", "Score")
        dat$Item <- factor(dat$Item)
        
        model <- lmer(Score ~ (1|Student) + (1|Item),dat)
        
        } else { # in case of "pri"

        # 得点以外を因子の型に変更
        dat$Student <- factor(dat$Student)
        dat$Rater <- factor(dat$Rater)
        dat$Item <- factor(dat$Item)
    
        model <- lmer(Score ~ 1 + (1|Rater) + (1|Student) + (1|Item) + (1|Student:Rater) + (1|Student:Item) + (1|Rater:Item), data=dat)
        
        }
        
        list(model = model) # To be used later
        
        
    })





################################################
# Variance components (Sorted)
################################################

   var.est <- reactive({
        
        dat <- read.csv(text=input$text, sep="\t")
        
        
        if (input$type == "pi") {
            
            dat$Student <- factor(rownames(dat)) # id番号付与
            col.n <- length(dat)-1
            dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction = "long")
            dat <- dat[,-1]
            colnames(dat) <- c("Student", "Item", "Score")
            dat$Item <- factor(dat$Item)
            
            model <- lmer(Score ~ (1|Student) + (1|Item),dat)
            
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Item")
            
        } else { # in case of "pri"
            
            dat$Student <- factor(dat$Student)
            dat$Rater <- factor(dat$Rater)
            dat$Item <- factor(dat$Item)
        
            counts <- list(length(levels(dat$Rater)),length(levels(dat$Item)))
            names(counts) <- c("Rater","Item")
            model <- lmer(Score ~ (1|Student) + (1|Rater) + (1|Item) + (1|Student:Rater) + (1|Student:Item) + (1|Item:Rater), dat)
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Rater","Item","Student:Rater","Student:Item","Item:Rater")
        
        }
        
        varCompTable <- function(vcomp,vcompLbls) {
            compOut <- c()
            lbl <- c()
            for(i in 1:length(vcomp)){
                compOut[i] <- vcomp[[vcompLbls[i]]][,1]
                lbl[i] <- vcompLbls[i]
            }
            compOut[length(vcomp)+1] <- attr(vcomp, "sc")[[1]]^2
            lbl[length(vcomp)+1] <- "Residual"
            
            compTbl <- data.frame(round(compOut,3),round(compOut/sum(compOut),3)*100)
            #rownames(compTbl) <- lbl
            rownames(compTbl) <- gsub(":","*",lbl)
            colnames(compTbl) <- c("VarComp","%")
            
            compTblTemp <- compTbl[1:(nrow(compTbl)-1),]
            compTblTemp <- compTblTemp[order(compTblTemp[,1],decreasing=T),]
            compTblOrderd <- rbind(compTblTemp,compTbl[nrow(compTbl),])
            cat("Variance components\n\n")
            print(compTbl)
            cat("\nVariance components (Sorted)\n\n")
            print(compTblOrderd)
        }
        
        varCompTable(vcomp, vcompLbls)
    
   })





################################################
# G-coefficient
################################################

    g.coef <- reactive({
        
        dat <- read.csv(text=input$text, sep="\t")
        
        
        
        if (input$type == "pi") {
            
            dat$Student <- factor(rownames(dat)) # id番号付与
            col.n <- length(dat)-1
            dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction = "long")
            dat <- dat[,-1]
            colnames(dat) <- c("Student", "Item", "Score")
            dat$Item <- factor(dat$Item)
            
            counts <- length(levels(dat$Item))
            names(counts) <- c("Item")
            
            model <- lmer(Score ~ (1|Student) + (1|Item),dat)
            
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Item")
            
        } else { # in case of "pri"
            
            dat$Student <- factor(dat$Student)
            dat$Rater <- factor(dat$Rater)
            dat$Item <- factor(dat$Item)
            
            counts <- list(length(levels(dat$Rater)),length(levels(dat$Item)))
            names(counts) <- c("Rater","Item")
            model <- lmer(Score ~ (1|Student) + (1|Rater) + (1|Item) + (1|Student:Rater) + (1|Student:Item) + (1|Item:Rater), dat)
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Rater","Item","Student:Rater","Student:Item","Item:Rater")
            
        }
        
        
        calcGCoefficient <- function(uniVal,vcomp,vcompLbls,ids,counts) {
            denoms <- c()
            denomsVal <- c()
            denoms[1] <- "as.numeric(vcomp[[uniVal]])"
            denomsVal[1] <- as.numeric(vcomp[[uniVal]])
            if (length(ids) > 0) {
                for(i in 1:length(ids)) {
                    denomItem <- gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[i]])
                    if (length(grep(":",denomItem)) > 0){
                        items <- strsplit(denomItem,":")
                        countNums <- c()
                        for (j in 1:length(items[[1]])) {
                            countNums[j] <- counts[[items[[1]][j]]]
                        }
                        denoms[i+1] <- paste('(as.numeric(vcomp[[vcompLbls[ids[',i,']]]]) / ',prod(countNums),')',sep="")
                        denomsVal[i+1] <- as.numeric(vcomp[[vcompLbls[ids[i]]]]) / prod(countNums)
                    } else {
                        denoms[i+1] <- paste('(as.numeric(vcomp[[vcompLbls[ids[',i,']]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[',i,']])]])',sep="")
                        denomsVal[i+1] <- as.numeric(vcomp[[vcompLbls[ids[i]]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[i]])]]
                    }
                }
            }
            
            countNums <- c()
            for (i in 1:length(counts)) {
                countNums[i] <- counts[[i]]
            }
            denoms[length(denoms) + 1] <- '(attr(vcomp, "sc")[[1]]^2 / prod(countNums))'
            denomsVal[length(denomsVal) + 1] <- attr(vcomp, "sc")[[1]]^2 / prod(countNums)
            return(eval(parse(text=paste(denoms[1],"/ (",paste(denoms,collapse=" + "),")"))))
        }

        gcoeff <- calcGCoefficient("Student",vcomp,vcompLbls,grep(":Student\\b|\\bStudent:",vcompLbls),counts)

        cat("G =", substr(sprintf("%.3f", round(gcoeff, 3)), 2, 5))

    })
    
    
    
    

################################################
# Phi
################################################

    phi <- reactive({
    
        dat <- read.csv(text=input$text, sep="\t")
    
    
        if (input$type == "pi") {
        
            dat$Student <- factor(rownames(dat)) # id番号付与
            col.n <- length(dat)-1
            dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction = "long")
            dat <- dat[,-1]
            colnames(dat) <- c("Student", "Item", "Score")
            dat$Item <- factor(dat$Item)
        
            counts <- length(levels(dat$Item))
            names(counts) <- c("Item")
        
            model <- lmer(Score ~ (1|Student) + (1|Item),dat)
        
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Item")
        
        } else { # in case of "pri"
        
            dat$Student <- factor(dat$Student)
            dat$Rater <- factor(dat$Rater)
            dat$Item <- factor(dat$Item)
        
            counts <- list(length(levels(dat$Rater)),length(levels(dat$Item)))
            names(counts) <- c("Rater","Item")
            model <- lmer(Score ~ (1|Student) + (1|Rater) + (1|Item) + (1|Student:Rater) + (1|Student:Item) + (1|Item:Rater), dat)
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Rater","Item","Student:Rater","Student:Item","Item:Rater")
        
        }



        calcPhiCoefficient <- function(uniVal,vcomp,vcompLbls,counts) {
            denoms <- c()
            denomsVal <- c()
            denoms[1] <- "as.numeric(vcomp[[uniVal]])"
            denomsVal[1] <- as.numeric(vcomp[[uniVal]])
            if (length(vcompLbls) > 2) {
                for(i in 2:length(vcompLbls)) {
                    denomItem <- gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[i])
                    if (length(grep(":",denomItem)) > 0){
                        items <- strsplit(denomItem,":")
                        countNums <- c()
                        for (j in 1:length(items[[1]])) {
                            countNums[j] <- counts[[items[[1]][j]]]
                        }
                        denoms[i] <- paste('(as.numeric(vcomp[[vcompLbls[',i,']]]) / ',prod(countNums),')',sep="")
                        denomsVal[i] <- as.numeric(vcomp[[vcompLbls[i]]]) / prod(countNums)
                    } else {
                        denoms[i] <- paste('(as.numeric(vcomp[[vcompLbls[',i,']]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[',i,'])]])',sep="")
                        denomsVal[i] <- as.numeric(vcomp[[vcompLbls[i]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[i])]]
                    }
                }
            } else {
                denoms[2] <- paste('(as.numeric(vcomp[[vcompLbls[2]]]) / ',prod(counts[[1]]),')',sep="")
                denomsVal[2] <- as.numeric(vcomp[[vcompLbls[2]]]) / prod(counts[[1]])
            }
            countNums <- c()
            for (i in 1:length(counts)) {
                countNums[i] <- counts[[i]]
            }
            denoms[length(denoms) + 1] <- '(attr(vcomp, "sc")[[1]]^2 / prod(countNums))'
            denomsVal[length(denomsVal) + 1] <- attr(vcomp, "sc")[[1]]^2 / prod(countNums)
            return(eval(parse(text=paste(denoms[1],"/ (",paste(denoms,collapse=" + "),")"))))
        }
        
        phi <- calcPhiCoefficient("Student",vcomp,vcompLbls,counts)
        cat("Φ =", substr(sprintf("%.3f",round(phi,3)),2,5))
    
    })




################################################
# D study
################################################

    D <- reactive({
    
    
        if (input$type == "pi") {

            model <- mod()$model
    
            vcomp <- VarCorr(model)
        
            dat <- read.csv(text=input$text, sep="\t")
            
            dat$Student <- factor(rownames(dat)) # id番号付与
            col.n <- length(dat)-1
            dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction = "long")
            dat <- dat[,-1]
            colnames(dat) <- c("Student", "Item", "Score")
            dat$Item <- factor(dat$Item)
            
            counts <- length(levels(dat$Item))
            names(counts) <- c("Item")
            
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Item")
    
    
        } else { # in case of "pri"

            model <- mod()$model

            vcomp <- VarCorr(model)

            dat <- read.csv(text=input$text, sep="\t")

            dat$Student <- factor(dat$Student)
            dat$Rater <- factor(dat$Rater)
            dat$Item <- factor(dat$Item)

            counts <- list(length(levels(dat$Rater)),length(levels(dat$Item)))
            names(counts) <- c("Rater","Item")

            vcompLbls <- c("Student","Rater","Item","Student:Rater","Student:Item","Item:Rater")

        }




        calcGCoefficient <- function(uniVal,vcomp,vcompLbls,ids,counts) {
            denoms <- c()
            denomsVal <- c()
            denoms[1] <- "as.numeric(vcomp[[uniVal]])"
            denomsVal[1] <- as.numeric(vcomp[[uniVal]])
            if (length(ids) > 0) {
                for(i in 1:length(ids)) {
                    denomItem <- gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[i]])
                    if (length(grep(":",denomItem)) > 0){
                        items <- strsplit(denomItem,":")
                        countNums <- c()
                        for (j in 1:length(items[[1]])) {
                            countNums[j] <- counts[[items[[1]][j]]]
                        }
                        denoms[i+1] <- paste('(as.numeric(vcomp[[vcompLbls[ids[',i,']]]]) / ',prod(countNums),')',sep="")
                        denomsVal[i+1] <- as.numeric(vcomp[[vcompLbls[ids[i]]]]) / prod(countNums)
                    } else {
                        denoms[i+1] <- paste('(as.numeric(vcomp[[vcompLbls[ids[',i,']]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[',i,']])]])',sep="")
                        denomsVal[i+1] <- as.numeric(vcomp[[vcompLbls[ids[i]]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[i]])]]
                    }
                }
            }
        
            countNums <- c()
            for (i in 1:length(counts)) {
                countNums[i] <- counts[[i]]
            }
            denoms[length(denoms) + 1] <- '(attr(vcomp, "sc")[[1]]^2 / prod(countNums))'
            denomsVal[length(denomsVal) + 1] <- attr(vcomp, "sc")[[1]]^2 / prod(countNums)
            return(eval(parse(text=paste(denoms[1],"/ (",paste(denoms,collapse=" + "),")"))))
        }
        
        
        
        
        
        
        if (input$type == "pi") {
            
            n.items <- input$n.items
            
            ival <- 1:n.items
            ival <- as.numeric(ival)
            
            plotValsG <- c()
            plotVals <- c()
                for(i in 1:length(ival)) {
                    counts[[1]] <- ival[i]
                    plotValsG[i] <- calcGCoefficient("Student",vcomp,vcompLbls,grep(":Student\\b|\\bStudent:",vcompLbls),counts)
                }
            
            cat("G-coefficients\n\n")
            gvals <- data.frame(substr(matrix(sprintf("%.3f",round(plotValsG,3)),ncol=1),2,5))
            colnames(gvals) <- c("G-coefficients")
            rownames(gvals) <- paste("Item","=",ival)
            print(gvals)
        
        
        } else { # in case of "pri"

            n.raters <- input$n.raters
            n.items <- input$n.items
        
            ival <- 1:n.raters
            ival <- as.numeric(ival)
            jval <- 1:n.items
            jval <- as.numeric(jval)
            
            if(length(counts) > 1) {
                plotValsG <- matrix(nrow=length(ival),ncol=length(jval))
                    for(i in 1:length(ival)) {
                        for(j in 1:length(jval)) {
                            counts[[1]] <- ival[i]
                            counts[[2]] <- jval[j]
                            plotValsG[i,j] <- calcGCoefficient("Student",vcomp,vcompLbls,grep(":Student\\b|\\bStudent:",vcompLbls),counts)
                        }
            }
            
            cat("G-coefficients (row: Rater, column: Item)\n\n")
            gvals <- data.frame(substr(matrix(sprintf("%.3f",round(plotValsG,3)),ncol=ncol(plotValsG)),2,5))
            colnames(gvals) <- jval
            rownames(gvals) <- paste("Rater","=",ival)
            print(gvals)
            
            }
      
        }
        
    })




################################################
# plot
################################################

    makePlot <- function(){
        
        
        if (input$type == "pi") {
            
            model <- mod()$model
            
            vcomp <- VarCorr(model)
            
            dat <- read.csv(text=input$text, sep="\t")
            
            dat$Student <- factor(rownames(dat)) # id番号付与
            col.n <- length(dat)-1
            dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction = "long")
            dat <- dat[,-1]
            colnames(dat) <- c("Student", "Item", "Score")
            dat$Item <- factor(dat$Item)
            
            counts <- length(levels(dat$Item))
            names(counts) <- c("Item")
            
            vcomp <- VarCorr(model)
            vcompLbls <- c("Student","Item")
            
            
        } else { # in case of "pri"
            
            model <- mod()$model
            
            vcomp <- VarCorr(model)
            
            dat <- read.csv(text=input$text, sep="\t")
            
            dat$Student <- factor(dat$Student)
            dat$Rater <- factor(dat$Rater)
            dat$Item <- factor(dat$Item)
            
            counts <- list(length(levels(dat$Rater)),length(levels(dat$Item)))
            names(counts) <- c("Rater","Item")
            
            vcompLbls <- c("Student","Rater","Item","Student:Rater","Student:Item","Item:Rater")
            
        }
        
        
        
        
        calcGCoefficient <- function(uniVal,vcomp,vcompLbls,ids,counts) {
            denoms <- c()
            denomsVal <- c()
            denoms[1] <- "as.numeric(vcomp[[uniVal]])"
            denomsVal[1] <- as.numeric(vcomp[[uniVal]])
            if (length(ids) > 0) {
                for(i in 1:length(ids)) {
                    denomItem <- gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[i]])
                    if (length(grep(":",denomItem)) > 0){
                        items <- strsplit(denomItem,":")
                        countNums <- c()
                        for (j in 1:length(items[[1]])) {
                            countNums[j] <- counts[[items[[1]][j]]]
                        }
                        denoms[i+1] <- paste('(as.numeric(vcomp[[vcompLbls[ids[',i,']]]]) / ',prod(countNums),')',sep="")
                        denomsVal[i+1] <- as.numeric(vcomp[[vcompLbls[ids[i]]]]) / prod(countNums)
                    } else {
                        denoms[i+1] <- paste('(as.numeric(vcomp[[vcompLbls[ids[',i,']]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[',i,']])]])',sep="")
                        denomsVal[i+1] <- as.numeric(vcomp[[vcompLbls[ids[i]]]]) / counts[[gsub(paste(":",uniVal,"|",uniVal,":",sep=""),"",vcompLbls[ids[i]])]]
                    }
                }
            }
            
            countNums <- c()
            for (i in 1:length(counts)) {
                countNums[i] <- counts[[i]]
            }
            denoms[length(denoms) + 1] <- '(attr(vcomp, "sc")[[1]]^2 / prod(countNums))'
            denomsVal[length(denomsVal) + 1] <- attr(vcomp, "sc")[[1]]^2 / prod(countNums)
            return(eval(parse(text=paste(denoms[1],"/ (",paste(denoms,collapse=" + "),")"))))
        }
        
        
        
        
        
        
        if (input$type == "pi") {
            
            n.items <- input$n.items
            
            ival <- 1:n.items
            ival <- as.numeric(ival)
            
            plotValsG <- c()
            plotVals <- c()
            for(i in 1:length(ival)) {
                counts[[1]] <- ival[i]
                plotValsG[i] <- calcGCoefficient("Student",vcomp,vcompLbls,grep(":Student\\b|\\bStudent:",vcompLbls),counts)
            }
            
            cat("G-coefficients (row: Rater, column: Item)\n\n")
            gvals <- data.frame(substr(matrix(sprintf("%.3f",round(plotValsG,3)),ncol=1),2,5))
            colnames(gvals) <- c("G-coefficients")
            rownames(gvals) <- paste("Rater","=",ival)
            
            plot(c(0,0),xlim=c(min(ival),max(ival)),ylim=c(0, 1),type="n",xlab="Items",ylab="G-coefficients")
            axis(side=2, at=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1))
            axis(side=1, at=ival)
            points(plotValsG, pch=1, col=1);lines(plotValsG, col=1, lty=1)
            
            
        } else { # in case of "pri"
            
            n.raters <- input$n.raters
            n.items <- input$n.items
            
            ival <- 1:n.raters
            ival <- as.numeric(ival)
            jval <- 1:n.items
            jval <- as.numeric(jval)
            
            plotValsG <- matrix(nrow=length(ival),ncol=length(jval))
            for(i in 1:length(ival)) {
                for(j in 1:length(jval)) {
                    counts[[1]] <- ival[i]
                    counts[[2]] <- jval[j]
                    plotValsG[i,j] <- calcGCoefficient("Student",vcomp,vcompLbls,grep(":Student\\b|\\bStudent:",vcompLbls),counts)
                }
            }
            
            cat("G-coefficients (row: Rater, column: Item)\n\n")
            gvals <- data.frame(substr(matrix(sprintf("%.3f",round(plotValsG,3)),ncol=ncol(plotValsG)),2,5))
            colnames(gvals) <- jval
            rownames(gvals) <- paste("Rater","=",ival)
            
            lbls <- c()
            for (i in 1:n.raters) {
                lbls[i] <- paste("Rater =",i)
            }
            
            plot(c(0,0),xlim=c(min(jval),max(jval)),ylim=c(0, 1),type="n",xlab="Items",ylab="G-coefficients")
            axis(side=2, at=c(0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1))
            axis(side=1, at=jval)
            legend("topleft", cex=0.7, legend = lbls, lty = c(1:n.raters), pch = c(1:n.raters), col = c(1:n.raters))
            for(i in 1:nrow(plotValsG)) {
                points(plotValsG[i,], pch=i, col=i);lines(plotValsG[i,], col=i, lty=i)
            }
            
        }
        
    }
    
    
    output$Plot <- renderPlot({
        print(makePlot())
    })
    
    



################################################
# R session info
################################################

    info <- reactive({
        info1 <- paste("This analysis was conducted with ", strsplit(R.version$version.string, " \\(")[[1]][1], ".", sep = "")# バージョン情報
        info2 <- paste("It was executed on ", date(), ".", sep = "")# 実行日時
        cat(sprintf(info1), "\n")
        cat(sprintf(info2), "\n")
    })
    
    
    
    
    
################################################
# server.R and ui.R connection
################################################

    output$info.out <- renderPrint({
        info()
    })
    
    
    
    
    
    output$var.est.out <- renderPrint({
        var.est()
    })
    
    output$g.coef.out <- renderPrint({
        g.coef()
    })
    
    output$phi.out <- renderPrint({
        phi()
    })
    
    output$D.out <- renderPrint({
        D()
    })


})

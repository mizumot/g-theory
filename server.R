library(shiny)
library(shinyAce)

# ANOVAベースのG理論計算

shinyServer(function(input, output) {

# p × i デザインの分散成分推定
estimate_var_pi <- function(dat) {
    dat$Student <- factor(dat$Student)
    dat$Item <- factor(dat$Item)
    
    np <- length(levels(dat$Student))
    ni <- length(levels(dat$Item))
    
    aov_result <- aov(Score ~ Student + Item, data = dat)
    aov_summary <- summary(aov_result)[[1]]
    
    # 行名のスペースを除去
    rownames(aov_summary) <- trimws(rownames(aov_summary))
    
    MS_p <- aov_summary["Student", "Mean Sq"]
    MS_i <- aov_summary["Item", "Mean Sq"]
    MS_res <- aov_summary["Residuals", "Mean Sq"]
    
    var_p <- max(0, (MS_p - MS_res) / ni)
    var_i <- max(0, (MS_i - MS_res) / np)
    var_res <- MS_res
    
    list(Student = var_p, Item = var_i, Residual = var_res,
         counts = list(Item = ni), np = np, ni = ni)
}

# p × r × i デザインの分散成分推定
estimate_var_pri <- function(dat) {
    dat$Student <- factor(dat$Student)
    dat$Rater <- factor(dat$Rater)
    dat$Item <- factor(dat$Item)
    
    np <- length(levels(dat$Student))
    nr <- length(levels(dat$Rater))
    ni <- length(levels(dat$Item))
    
    aov_result <- aov(Score ~ Student * Rater * Item, data = dat)
    aov_summary <- summary(aov_result)[[1]]
    
    # 行名のスペースを除去
    rownames(aov_summary) <- trimws(rownames(aov_summary))
    
    MS_p <- aov_summary["Student", "Mean Sq"]
    MS_r <- aov_summary["Rater", "Mean Sq"]
    MS_i <- aov_summary["Item", "Mean Sq"]
    MS_pr <- aov_summary["Student:Rater", "Mean Sq"]
    MS_pi <- aov_summary["Student:Item", "Mean Sq"]
    MS_ri <- aov_summary["Rater:Item", "Mean Sq"]
    
    # 三元交互作用を残差として使用
    MS_res <- aov_summary["Student:Rater:Item", "Mean Sq"]
    
    var_p <- max(0, (MS_p - MS_pr - MS_pi + MS_res) / (nr * ni))
    var_r <- max(0, (MS_r - MS_pr - MS_ri + MS_res) / (np * ni))
    var_i <- max(0, (MS_i - MS_pi - MS_ri + MS_res) / (np * nr))
    var_pr <- max(0, (MS_pr - MS_res) / ni)
    var_pi <- max(0, (MS_pi - MS_res) / nr)
    var_ri <- max(0, (MS_ri - MS_res) / np)
    var_res <- MS_res
    
    list(Student = var_p, Rater = var_r, Item = var_i,
         "Student:Rater" = var_pr, "Student:Item" = var_pi, "Rater:Item" = var_ri,
         Residual = var_res, counts = list(Rater = nr, Item = ni),
         np = np, nr = nr, ni = ni)
}

var.est <- reactive({
    dat <- read.csv(text=input$text, sep="\t")
    
    if (input$type == "pi") {
        dat$Student <- factor(rownames(dat))
        col.n <- length(dat)-1
        dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction="long")
        dat <- dat[,-1]
        colnames(dat) <- c("Student", "Item", "Score")
        vc <- estimate_var_pi(dat)
        compOut <- c(vc$Student, vc$Item, vc$Residual)
        lbl <- c("Student", "Item", "Residual")
    } else {
        vc <- estimate_var_pri(dat)
        compOut <- c(vc$Student, vc$Rater, vc$Item, 
                     vc[["Student:Rater"]], vc[["Student:Item"]], vc[["Rater:Item"]], 
                     vc$Residual)
        lbl <- c("Student", "Rater", "Item", "Student*Rater", "Student*Item", "Rater*Item", "Residual")
    }
    
    compTbl <- data.frame(VarComp = round(compOut, 3), Percent = round(compOut/sum(compOut) * 100, 1))
    rownames(compTbl) <- lbl
    colnames(compTbl) <- c("VarComp", "%")
    
    compTblTemp <- compTbl[1:(nrow(compTbl)-1),]
    compTblTemp <- compTblTemp[order(compTblTemp[,1], decreasing=T),]
    compTblOrderd <- rbind(compTblTemp, compTbl[nrow(compTbl),])
    
    cat("Variance components\n\n")
    print(compTbl)
    cat("\nVariance components (Sorted)\n\n")
    print(compTblOrderd)
})

g.coef <- reactive({
    dat <- read.csv(text=input$text, sep="\t")
    
    if (input$type == "pi") {
        dat$Student <- factor(rownames(dat))
        col.n <- length(dat)-1
        dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction="long")
        dat <- dat[,-1]
        colnames(dat) <- c("Student", "Item", "Score")
        vc <- estimate_var_pi(dat)
        ni <- vc$ni
        gcoeff <- vc$Student / (vc$Student + vc$Residual/ni)
    } else {
        vc <- estimate_var_pri(dat)
        nr <- vc$nr
        ni <- vc$ni
        gcoeff <- vc$Student / (vc$Student + vc[["Student:Rater"]]/nr + vc[["Student:Item"]]/ni + vc$Residual/(nr*ni))
    }
    cat("G =", sprintf("%.3f", round(gcoeff, 3)))
})

phi <- reactive({
    dat <- read.csv(text=input$text, sep="\t")
    
    if (input$type == "pi") {
        dat$Student <- factor(rownames(dat))
        col.n <- length(dat)-1
        dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction="long")
        dat <- dat[,-1]
        colnames(dat) <- c("Student", "Item", "Score")
        vc <- estimate_var_pi(dat)
        ni <- vc$ni
        phi_val <- vc$Student / (vc$Student + vc$Item/ni + vc$Residual/ni)
    } else {
        vc <- estimate_var_pri(dat)
        nr <- vc$nr
        ni <- vc$ni
        phi_val <- vc$Student / (vc$Student + vc$Rater/nr + vc$Item/ni + 
                                 vc[["Student:Rater"]]/nr + vc[["Student:Item"]]/ni + 
                                 vc[["Rater:Item"]]/(nr*ni) + vc$Residual/(nr*ni))
    }
    cat("Phi =", sprintf("%.3f", round(phi_val, 3)))
})

D <- reactive({
    dat <- read.csv(text=input$text, sep="\t")
    
    if (input$type == "pi") {
        dat$Student <- factor(rownames(dat))
        col.n <- length(dat)-1
        dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction="long")
        dat <- dat[,-1]
        colnames(dat) <- c("Student", "Item", "Score")
        vc <- estimate_var_pi(dat)
        n.items <- input$n.items
        ival <- 1:n.items
        gvals <- sapply(ival, function(ni) vc$Student / (vc$Student + vc$Residual/ni))
        cat("G-coefficients\n\n")
        result <- data.frame(G = sprintf("%.3f", round(gvals, 3)))
        rownames(result) <- paste("Item =", ival)
        print(result)
    } else {
        vc <- estimate_var_pri(dat)
        n.raters <- input$n.raters
        n.items <- input$n.items
        ival <- 1:n.raters
        jval <- 1:n.items
        plotValsG <- matrix(nrow=length(ival), ncol=length(jval))
        for(i in 1:length(ival)) {
            for(j in 1:length(jval)) {
                nr <- ival[i]
                ni <- jval[j]
                plotValsG[i,j] <- vc$Student / (vc$Student + vc[["Student:Rater"]]/nr + vc[["Student:Item"]]/ni + vc$Residual/(nr*ni))
            }
        }
        cat("G-coefficients (row: Rater, column: Item)\n\n")
        gvals <- data.frame(matrix(sprintf("%.3f", round(plotValsG, 3)), ncol=ncol(plotValsG)))
        colnames(gvals) <- jval
        rownames(gvals) <- paste("Rater =", ival)
        print(gvals)
    }
})

makePlot <- function(){
    dat <- read.csv(text=input$text, sep="\t")
    
    if (input$type == "pi") {
        dat$Student <- factor(rownames(dat))
        col.n <- length(dat)-1
        dat <- reshape(dat, idvar="Student", varying=2:col.n, v.names="Score", direction="long")
        dat <- dat[,-1]
        colnames(dat) <- c("Student", "Item", "Score")
        vc <- estimate_var_pi(dat)
        n.items <- input$n.items
        ival <- 1:n.items
        plotValsG <- sapply(ival, function(ni) vc$Student / (vc$Student + vc$Residual/ni))
        plot(ival, plotValsG, xlim=c(1, max(ival)), ylim=c(0, 1), type="b", pch=1, col=1, lty=1,
             xlab="Items", ylab="G-coefficients", main="D Study: G-coefficients by Number of Items")
        abline(h=0.8, lty=2, col="gray")
    } else {
        vc <- estimate_var_pri(dat)
        n.raters <- input$n.raters
        n.items <- input$n.items
        ival <- 1:n.raters
        jval <- 1:n.items
        plotValsG <- matrix(nrow=length(ival), ncol=length(jval))
        for(i in 1:length(ival)) {
            for(j in 1:length(jval)) {
                nr <- ival[i]
                ni <- jval[j]
                plotValsG[i,j] <- vc$Student / (vc$Student + vc[["Student:Rater"]]/nr + vc[["Student:Item"]]/ni + vc$Residual/(nr*ni))
            }
        }
        lbls <- paste("Rater =", ival)
        plot(c(0,0), xlim=c(1, max(jval)), ylim=c(0, 1), type="n",
             xlab="Items", ylab="G-coefficients", main="D Study")
        abline(h=0.8, lty=2, col="gray")
        legend("bottomright", cex=0.7, legend=lbls, lty=1:n.raters, pch=1:n.raters, col=1:n.raters)
        for(i in 1:nrow(plotValsG)) {
            points(jval, plotValsG[i,], pch=i, col=i)
            lines(jval, plotValsG[i,], col=i, lty=i)
        }
    }
}

output$Plot <- renderPlot({ makePlot() })

info <- reactive({
    info1 <- paste("This analysis was conducted with ", strsplit(R.version$version.string, " \\(")[[1]][1], ".", sep = "")
    info2 <- paste("It was executed on ", date(), ".", sep = "")
    cat(sprintf(info1), "\n")
    cat(sprintf(info2), "\n")
})

output$info.out <- renderPrint({ info() })
output$var.est.out <- renderPrint({ var.est() })
output$g.coef.out <- renderPrint({ g.coef() })
output$phi.out <- renderPrint({ phi() })
output$D.out <- renderPrint({ D() })

})

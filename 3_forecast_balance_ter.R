#This code provides two outcomes: 
#(1) volume forecasting for all Ter system (SAU+SUSQUEDA) and
#(2) probabilistic plots:
#Created by D. Mercado-Bettín

library(lubridate);library(dplyr)

dir <- "/home/rmarce/volume_ter/"
setwd(dir)

year_initial <- 2024
month_initial <- "04"
members <- 51
fix_plot <- FALSE #to set as default plots and csv outputs
plot_actual <- TRUE #plot current season

#initialisation forecast
date_ini <- as.Date(paste0(year_initial,"-",month_initial,"-01"))
all_dates <- seq(from=date_ini, by=1, len=215)
#previous year forecast
date_ini_previous <- as.Date(paste0(year(all_dates[1])-1, "-",month(all_dates[1]), "-01"))
dates_previous <- seq(from=date_ini_previous, by=1, len=215)

#RAFA: no entiendo como se trabaja esto... a lo mejor no hace falta..
#add ACA data
#dates_aca <- seq(as.Date("2023-04-01"), as.Date("2025-05-31"),1)
dates_aca <- seq(as.Date(paste0((year_initial-1),"-04-01")), 
                 as.Date(paste0((year_initial+1),"-05-31")),1)
aca_min <- read.csv("in/aca_report_min.csv", header = F)
aca_min$dates <- dates_aca[round(aca_min$V1)]
aca_p5 <- read.csv("in/aca_report_p5.csv", header = F)
aca_p5$dates <- dates_aca[round(aca_p5$V1)]
aca_p15 <- read.csv("in/aca_report_p15.csv", header = F)
aca_p15$dates <- dates_aca[round(aca_p15$V1)]
aca_p25 <- read.csv("in/aca_report_p25.csv", header = F)
aca_p25$dates <- dates_aca[round(aca_p25$V1)]
aca_p50 <- read.csv("in/aca_report_p50.csv", header = F)
aca_p50$dates <- dates_aca[round(aca_p50$V1)]

get_col_transparent <- function(color, alpha) {
  rgb_vals <- col2rgb(color) / 255  # Convert to 0-1 scale
  rgb(rgb_vals[1], rgb_vals[2], rgb_vals[3], alpha = alpha)
}

#load sau and sqd volumes
V_sau <- read.csv(paste0("out/forecast_sau/for_V_sau_",year_initial,"_",month_initial,".csv"))
V_sqd <- read.csv(paste0("out/forecast_sqd/for_V_sqd_",year_initial,"_",month_initial,".csv"))

V_total <- V_sau[2:ncol(V_sau)] + V_sqd[2:ncol(V_sqd)]

#load sau and sqd balances
sqd_balance <- read.csv("out/calculated_sqd.csv")
sau_balance <- read.csv("out/calculated_sau.csv")
ter_balance_V <- sqd_balance$V + sau_balance$V
#current balance for the actual dates
sqd_balance_actual <- read.csv("in/water_balance_sqd.csv")
sau_balance_actual <- read.csv("in/water_balance_sau.csv")
ter_balance_actual_V <- sqd_balance_actual$V+sau_balance_actual$V

pdf(paste0("plot/3_forecast_ter_",year_initial,"_",month_initial,".pdf"),width=8)
code2 <- "Plotting_ter_forecast.R"
source(paste0(dir,code2)) #to avoid modifying things 4 times everytime we change something in the plot
dev.off()

png(paste0("plot/3_forecast_ter_",year_initial,"_",month_initial,".png"), width = 700, height = 600, units = "px")
code2 <- "Plotting_ter_forecast.R"
source(paste0(dir,code2))
dev.off()

# pdf(paste0("plot/3_forecast_ter_ACA_",year_initial,"_",month_initial,".pdf"))
# #plot corrected volumes
# plot(as.Date(V_sau$date), V_total[,1], type="l", col="lightgray",
#      ylim=c(0,unique(sqd_balance$Vmax+sau_balance$Vmax)),  ylab="Volume Ter (hm³)", xlab="Date")
# for (i in 2:51){
#   lines(as.Date(V_sau$date), V_total[,i], col="lightgray")
# }
# 
# 
# #real dynamic previous year
# dates_plot <- dates_previous
# sel_pos <- as.Date(sqd_balance$date) %in% dates_plot
# #plot(sqd_balance$date[sel_pos],sqd_balance$V[sel_pos], type="l")
# lines(as.Date(V_sau$date),ter_balance_V[sel_pos][1:length(V_sau$date)], 
#       col="black", lwd=1.5)
# lines(as.Date(sau_balance_actual$date, format = "%m/%d/%Y"),ter_balance_actual_V, 
#       col="green", lwd=3)
# points(as.Date("03/14/2025",format = "%m/%d/%Y"),145,pch=19,  col="green")
# #ACA data
# # lines(aca_p50$dates, aca_p50$V2, lty=2 ,col="darkblue", lwd=3)
# # lines(aca_p25$dates, aca_p25$V2, lty=2 ,col="lightblue", lwd=3)
# # lines(aca_p15$dates, aca_p15$V2, lty=2 ,col="gray", lwd=3)
# # lines(aca_p5$dates, aca_p5$V2, lty=2 ,col="gold3", lwd=3)
# # lines(aca_min$dates, aca_min$V2, lty=2 ,col="darkred", lwd=3)
# 
# abline(200,0,lty=3)
# 
# abline(120,0,lty=3)
# abline(85,0,lty=3)
# abline(65,0,lty=3)
# abline(43,0,lty=3)
# abline(14,0,lty=3)
# 
# #Emergència III
# ini_date <- as.Date(V_sau$date)[1]
# end_date <- as.Date(V_sau$date)[dim(V_sau)[1]]
# rect(xleft = ini_date-30, ybottom = 0, 
#      xright = end_date+30, ytop = 14, 
#      col = get_col_transparent("brown3", 0.5), border = NA)
# #Emergència II
# rect(xleft = ini_date-30, ybottom = 14, 
#      xright = end_date+30, ytop = 42.6, 
#      col = get_col_transparent("brown1", 0.5), border = NA)
# #Emergència I
# rect(xleft = ini_date-30, ybottom = 42.6, 
#      xright = end_date+30, ytop = 64.60, 
#      col = get_col_transparent("coral1", 0.5), border = NA)
# #Excepcionalitat
# rect(xleft = ini_date-30, ybottom = 64.60, 
#      xright = end_date+30, ytop = 85.20, 
#      col = get_col_transparent("orange", 0.5), border = NA)
# #Alerta
# rect(xleft = ini_date-30, ybottom = 85.20, 
#      xright = end_date+30, ytop = 121, 
#      col = get_col_transparent("yellow", 0.5), border = NA)
# rect(xleft = as.Date("2023-02-01"), ybottom = 121, 
#      xright = end_date+30, ytop = 140, 
#      col = get_col_transparent("yellow", 0.5), border = NA)
# rect(xleft = as.Date("2023-03-01"), ybottom = 140, 
#      xright = end_date+30, ytop = 160, 
#      col = get_col_transparent("yellow", 0.5), border = NA)
# 
# # Ensemble percentiles
# # 0.90 and 0.10 percentiles
# upper_90 <- apply(V_total, 1, quantile, 0.90)
# lower_10 <- apply(V_total, 1, quantile, 0.1)
# 
# # Plot the shaded area between 0.90 and 0.10 percentiles with transparency
# polygon(c(as.Date(V_sau$date), rev(as.Date(V_sau$date))), 
#         c(upper_90, rev(lower_10)),
#         col=rgb(0, 0, 1, 0.2), border=NA)  # Red with transparency
# 
# # 0.75 and 0.25 percentiles
# upper_75 <- apply(V_total, 1, quantile, 0.75)
# lower_25 <- apply(V_total, 1, quantile, 0.25)
# 
# # Plot the shaded area between 0.75 and 0.25 percentiles with transparency
# polygon(c(as.Date(V_sau$date), rev(as.Date(V_sau$date))), 
#         c(upper_75, rev(lower_25)),
#         col=rgb(0, 0, 0.6, 0.3), border=NA)  # Dark red with transparency
# 
# # Plot the ensemble median
# lines(as.Date(V_sau$date), apply(V_total, 1, median), col="blue", lwd=3)
# 
# legend("topleft", legend=c("Ensemble", "51 members", 
#                            "Actual season", "Previous season", 
#                            "P50", "P25", "P15", "P5", "MIN"), 
#        col=c("red","lightgray",
#              "green","blue",
#              "darkblue","lightblue","gray","gold3","darkred"), 
#        lty=c(rep(1,4),rep(2,5)), cex=0.8, bty="n")
# dev.off()
# 
# png(paste0("plot/3_forecast_ter_ACA_",year_initial,"_",month_initial,".png"), width = 800, height = 600, units = "px")
# #plot corrected volumes
# plot(as.Date(V_sau$date), V_total[,1], type="l", col="lightgray",
#      ylim=c(0,unique(sqd_balance$Vmax+sau_balance$Vmax)),  ylab="Volume Ter (hm³)", xlab="Date")
# for (i in 2:51){
#   lines(as.Date(V_sau$date), V_total[,i], col="lightgray")
# }
# 
# #real dynamic previous year
# dates_plot <- dates_previous
# sel_pos <- as.Date(sqd_balance$date) %in% dates_plot
# #plot(sqd_balance$date[sel_pos],sqd_balance$V[sel_pos], type="l")
# lines(as.Date(V_sau$date),ter_balance_V[sel_pos][1:length(V_sau$date)], 
#       col="black", lwd=1.5)
# lines(as.Date(sau_balance_actual$date, format = "%m/%d/%Y"),ter_balance_actual_V, 
#       col="green", lwd=3)
# #ACA data
# lines(aca_p50$dates, aca_p50$V2, lty=2 ,col="darkblue", lwd=3)
# lines(aca_p25$dates, aca_p25$V2, lty=2 ,col="lightblue", lwd=3)
# lines(aca_p15$dates, aca_p15$V2, lty=2 ,col="gray", lwd=3)
# lines(aca_p5$dates, aca_p5$V2, lty=2 ,col="gold3", lwd=3)
# lines(aca_min$dates, aca_min$V2, lty=2 ,col="darkred", lwd=3)
# #Emergència III
# ini_date <- as.Date(V_sau$date)[1]
# end_date <- as.Date(V_sau$date)[dim(V_sau)[1]]
# rect(xleft = ini_date-30, ybottom = 0, 
#      xright = end_date+30, ytop = 14, 
#      col = get_col_transparent("brown3", 0.15), border = NA)
# #Emergència II
# rect(xleft = ini_date-30, ybottom = 14, 
#      xright = end_date+30, ytop = 42.6, 
#      col = get_col_transparent("brown1", 0.15), border = NA)
# #Emergència I
# rect(xleft = ini_date-30, ybottom = 42.6, 
#      xright = end_date+30, ytop = 64.60, 
#      col = get_col_transparent("coral1", 0.15), border = NA)
# #Excepcionalitat
# rect(xleft = ini_date-30, ybottom = 64.60, 
#      xright = end_date+30, ytop = 85.20, 
#      col = get_col_transparent("orange", 0.15), border = NA)
# #Alerta
# rect(xleft = ini_date-30, ybottom = 85.20, 
#      xright = end_date+30, ytop = 121, 
#      col = get_col_transparent("yellow", 0.15), border = NA)
# rect(xleft = as.Date("2025-02-01"), ybottom = 121, 
#      xright = end_date+30, ytop = 140, 
#      col = get_col_transparent("yellow", 0.15), border = NA)
# rect(xleft = as.Date("2025-03-01"), ybottom = 140, 
#      xright = end_date+30, ytop = 160, 
#      col = get_col_transparent("yellow", 0.15), border = NA)
# # Ensemble percentiles
# # 0.90 and 0.10 percentiles
# upper_90 <- apply(V_total, 1, quantile, 0.90)
# lower_10 <- apply(V_total, 1, quantile, 0.1)
# 
# # Plot the shaded area between 0.90 and 0.10 percentiles with transparency
# polygon(c(as.Date(V_sau$date), rev(as.Date(V_sau$date))), 
#         c(upper_90, rev(lower_10)),
#         col=rgb(0, 0, 1, 0.2), border=NA)  # Red with transparency
# 
# # 0.75 and 0.25 percentiles
# upper_75 <- apply(V_total, 1, quantile, 0.75)
# lower_25 <- apply(V_total, 1, quantile, 0.25)
# 
# # Plot the shaded area between 0.75 and 0.25 percentiles with transparency
# polygon(c(as.Date(V_sau$date), rev(as.Date(V_sau$date))), 
#         c(upper_75, rev(lower_25)),
#         col=rgb(0, 0, 0.6, 0.3), border=NA)  # Dark red with transparency
# 
# # Plot the ensemble median
# lines(as.Date(V_sau$date), apply(V_total, 1, median), col="blue", lwd=3)
# 
# legend("topleft", legend=c("Ensemble", "51 members", 
#                            "Actual season", "Previous season", 
#                            "P50", "P25", "P15", "P5", "MIN"), 
#        col=c("red","lightgray",
#              "green","blue",
#              "darkblue","lightblue","gray","gold3","darkred"), 
#        lty=c(rep(1,4),rep(2,5)), cex=0.8, bty="n")
# dev.off()

#RAFA: I did not update this because I do not understand the option
if (fix_plot){
  
 
  pdf("plot/3_forecast_ter.pdf",width=8)
  code2 <- "Plotting_ter_forecast.R"
  source(paste0(dir,code2))
  dev.off()
  
  png("plot/3_forecast_ter.png", width = 700, height = 600, units = "px")
  code2 <- "Plotting_ter_forecast.R"
  source(paste0(dir,code2))
  dev.off()
  
  # pdf("plot/3_forecast_ter_ACA.pdf")
  # #plot corrected volumes
  # plot(as.Date(V_sau$date), V_total[,1], type="l", col="lightgray",
  #      ylim=c(0,unique(sqd_balance$Vmax+sau_balance$Vmax)),  ylab="Volume Ter (hm³)", xlab="Date")
  # for (i in 2:51){
  #   lines(as.Date(V_sau$date), V_total[,i], col="lightgray")
  # }
  # #ensemble mean
  # lines(as.Date(V_sau$date), rowMeans(V_total), col="red", lwd=3)
  # #real dynamic previous year
  # dates_plot <- dates_previous
  # sel_pos <- as.Date(sqd_balance$date) %in% dates_plot
  # #plot(sqd_balance$date[sel_pos],sqd_balance$V[sel_pos], type="l")
  # lines(as.Date(V_sau$date),ter_balance_V[sel_pos][1:length(V_sau$date)], 
  #       col="blue", lwd=3)
  # lines(as.Date(sau_balance_actual$date, format = "%m/%d/%Y"),ter_balance_actual_V, 
  #       col="green", lwd=3)
  # #ACA data
  # lines(aca_p50$dates, aca_p50$V2, lty=2 ,col="darkblue", lwd=3)
  # lines(aca_p25$dates, aca_p25$V2, lty=2 ,col="lightblue", lwd=3)
  # lines(aca_p15$dates, aca_p15$V2, lty=2 ,col="gray", lwd=3)
  # lines(aca_p5$dates, aca_p5$V2, lty=2 ,col="gold3", lwd=3)
  # lines(aca_min$dates, aca_min$V2, lty=2 ,col="darkred", lwd=3)
  # #Emergència III
  # ini_date <- as.Date(V_sau$date)[1]
  # end_date <- as.Date(V_sau$date)[dim(V_sau)[1]]
  # rect(xleft = ini_date-30, ybottom = 0, 
  #      xright = end_date+30, ytop = 14, 
  #      col = get_col_transparent("brown3", 0.15), border = NA)
  # #Emergència II
  # rect(xleft = ini_date-30, ybottom = 14, 
  #      xright = end_date+30, ytop = 42.6, 
  #      col = get_col_transparent("brown1", 0.15), border = NA)
  # #Emergència I
  # rect(xleft = ini_date-30, ybottom = 42.6, 
  #      xright = end_date+30, ytop = 64.60, 
  #      col = get_col_transparent("coral1", 0.15), border = NA)
  # #Excepcionalitat
  # rect(xleft = ini_date-30, ybottom = 64.60, 
  #      xright = end_date+30, ytop = 85.20, 
  #      col = get_col_transparent("orange", 0.15), border = NA)
  # #Alerta
  # rect(xleft = ini_date-30, ybottom = 85.20, 
  #      xright = end_date+30, ytop = 121, 
  #      col = get_col_transparent("yellow", 0.15), border = NA)
  # rect(xleft = as.Date("2025-02-01"), ybottom = 121, 
  #      xright = end_date+30, ytop = 140, 
  #      col = get_col_transparent("yellow", 0.15), border = NA)
  # rect(xleft = as.Date("2025-03-01"), ybottom = 140, 
  #      xright = end_date+30, ytop = 160, 
  #      col = get_col_transparent("yellow", 0.15), border = NA)
  # 
  # legend("topleft", legend=c("Ensemble", "51 members", 
  #                            "Actual season", "Previous season", 
  #                            "P50", "P25", "P15", "P5", "MIN"), 
  #        col=c("red","lightgray",
  #              "green","blue",
  #              "darkblue","lightblue","gray","gold3","darkred"), 
  #        lty=c(rep(1,4),rep(2,5)), cex=0.8, bty="n")
  # dev.off()
  # 
  # png("plot/3_forecast_ter_ACA.png", width = 800, height = 600, units = "px")
  # #plot corrected volumes
  # plot(as.Date(V_sau$date), V_total[,1], type="l", col="lightgray",
  #      ylim=c(0,unique(sqd_balance$Vmax+sau_balance$Vmax)),  ylab="Volume Ter (hm³)", xlab="Date")
  # for (i in 2:51){
  #   lines(as.Date(V_sau$date), V_total[,i], col="lightgray")
  # }
  # #ensemble mean
  # lines(as.Date(V_sau$date), rowMeans(V_total), col="red", lwd=3)
  # #real dynamic previous year
  # dates_plot <- dates_previous
  # sel_pos <- as.Date(sqd_balance$date) %in% dates_plot
  # #plot(sqd_balance$date[sel_pos],sqd_balance$V[sel_pos], type="l")
  # lines(as.Date(V_sau$date),ter_balance_V[sel_pos][1:length(V_sau$date)], 
  #       col="blue", lwd=3)
  # lines(as.Date(sau_balance_actual$date, format = "%m/%d/%Y"),ter_balance_actual_V, 
  #       col="green", lwd=3)
  # #ACA data
  # lines(aca_p50$dates, aca_p50$V2, lty=2 ,col="darkblue", lwd=3)
  # lines(aca_p25$dates, aca_p25$V2, lty=2 ,col="lightblue", lwd=3)
  # lines(aca_p15$dates, aca_p15$V2, lty=2 ,col="gray", lwd=3)
  # lines(aca_p5$dates, aca_p5$V2, lty=2 ,col="gold3", lwd=3)
  # lines(aca_min$dates, aca_min$V2, lty=2 ,col="darkred", lwd=3)
  # #Emergència III
  # ini_date <- as.Date(V_sau$date)[1]
  # end_date <- as.Date(V_sau$date)[dim(V_sau)[1]]
  # rect(xleft = ini_date-30, ybottom = 0, 
  #      xright = end_date+30, ytop = 14, 
  #      col = get_col_transparent("brown3", 0.15), border = NA)
  # #Emergència II
  # rect(xleft = ini_date-30, ybottom = 14, 
  #      xright = end_date+30, ytop = 42.6, 
  #      col = get_col_transparent("brown1", 0.15), border = NA)
  # #Emergència I
  # rect(xleft = ini_date-30, ybottom = 42.6, 
  #      xright = end_date+30, ytop = 64.60, 
  #      col = get_col_transparent("coral1", 0.15), border = NA)
  # #Excepcionalitat
  # rect(xleft = ini_date-30, ybottom = 64.60, 
  #      xright = end_date+30, ytop = 85.20, 
  #      col = get_col_transparent("orange", 0.15), border = NA)
  # #Alerta
  # rect(xleft = ini_date-30, ybottom = 85.20, 
  #      xright = end_date+30, ytop = 121, 
  #      col = get_col_transparent("yellow", 0.15), border = NA)
  # rect(xleft = as.Date("2025-02-01"), ybottom = 121, 
  #      xright = end_date+30, ytop = 140, 
  #      col = get_col_transparent("yellow", 0.15), border = NA)
  # rect(xleft = as.Date("2025-03-01"), ybottom = 140, 
  #      xright = end_date+30, ytop = 160, 
  #      col = get_col_transparent("yellow", 0.15), border = NA)
  # 
  # legend("topleft", legend=c("Ensemble", "51 members", 
  #                            "Actual season", "Previous season", 
  #                            "P50", "P25", "P15", "P5", "MIN"), 
  #        col=c("red","lightgray",
  #              "green","blue",
  #              "darkblue","lightblue","gray","gold3","darkred"), 
  #        lty=c(rep(1,4),rep(2,5)), cex=0.8, bty="n")
  #dev.off()
  
}

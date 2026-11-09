# Generates cover.png, the title image of this post.
# Run from this folder: Rscript _cover.R
# (Leading underscore keeps Quarto from treating this file as a page.)

set.seed(11)
BLUE <- "#2C6E9B"; ORANGE <- "#C77B30"; GREY <- "#8A8F84"; GREEN <- "#3B8B5B"; RED <- "#B33A3A"
W <- 720; n <- 6; G <- 90; S <- W - n*G
seq_off <- function() sort(runif(n) * (W - (n-1)*G)) + (seq_len(n)-1)*G
x <- as.vector(replicate(40000, seq_off()))
h <- hist(x, breaks = seq(0, W, by = 8), plot = FALSE)
dens <- stats::filter(h$counts / mean(h$counts), rep(1/5, 5), circular = FALSE)
dens[is.na(dens)] <- (h$counts / mean(h$counts))[is.na(dens)]
mids <- h$mids

png("cover.png", width = 2400, height = 1260, res = 200, bg = "transparent")
par(mar = c(0, 0, 0, 0))
plot(NA, xlim = c(0, 24), ylim = c(0, 12.6), asp = 1, axes = FALSE, xlab = "", ylab = "")

# --- left: the day as a line between walls ---
x0 <- 1.2; x1 <- 9.8; yb <- 4.4
sx <- function(t) x0 + (x1 - x0) * t / W
dy <- 3.6 / max(dens)
polygon(c(sx(mids[1]), sx(mids), sx(tail(mids, 1))), c(yb, yb + dy * dens, yb),
        col = adjustcolor(ORANGE, 0.35), border = NA)
lines(sx(mids), yb + dy * dens, col = ORANGE, lwd = 5)
segments(x0, yb + dy * 1, x1, yb + dy * 1, col = GREY, lwd = 3, lty = 2)
segments(x0, yb, x1, yb, col = GREY, lwd = 6)
segments(c(x0, x1), yb - 0.9, c(x0, x1), yb + 4.4, col = GREY, lwd = 14, lend = 1)
d <- seq_off(); d <- pmin(pmax(d, 25), W - 25)
segments(sx(d), yb - 0.55, sx(d), yb - 0.05, col = RED, lwd = 9, lend = 1)

# --- middle: wrap arrow ---
arrows(10.9, 6.3, 13.0, 6.3, length = 0.22, lwd = 7, col = GREY, angle = 25)

# --- right: the circle ---
cx <- 18.4; cy <- 6.3; R <- 3.9
ang <- function(t) pi/2 - 2*pi*t/W
arc <- function(t1, t2, r, ...) { tt <- seq(t1, t2, length.out = 200)
  lines(cx + r*cos(ang(tt)), cy + r*sin(ang(tt)), ...) }
# flat density ring
tt <- seq(0, W, length.out = 400)
polygon(c(cx + (R+0.25)*cos(ang(tt)), rev(cx + (R+0.25+0.55)*cos(ang(tt)))),
        c(cy + (R+0.25)*sin(ang(tt)), rev(cy + (R+0.25+0.55)*sin(ang(tt)))),
        col = adjustcolor(BLUE, 0.22), border = NA)
arc(0, W, R, col = GREY, lwd = 4)
s <- G + diff(c(0, sort(runif(n - 1)), 1)) * S
phase <- 95
cum <- cumsum(c(0, s[-n]))
for (k in seq_len(n)) {
  a <- phase + cum[k]
  arc(a, a + G, R, col = BLUE, lwd = 22, lend = 1)
}
p <- phase + cum
points(cx + R*cos(ang(p)), cy + R*sin(ang(p)), pch = 21, bg = "white", col = RED, lwd = 6, cex = 4.2)
# rotation arrow inside
tt <- seq(250, 470, length.out = 100); r2 <- R - 1.1
lines(cx + r2*cos(ang(tt)), cy + r2*sin(ang(tt)), col = GREEN, lwd = 7)
arrows(cx + r2*cos(ang(455)), cy + r2*sin(ang(455)), cx + r2*cos(ang(470)), cy + r2*sin(ang(470)),
       length = 0.22, lwd = 7, col = GREEN, angle = 25)
dev.off()

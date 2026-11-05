library(ggplot2)
library(data.table)
library(mlr3)
library(mlr3misc)


set.seed(1)

shrink_prop = 0.97
colors = c("#0072B2", "#E69F00", "#CC79A7")
grey_dark = "grey26"
grey_light = "#456a64"
# grey_light = "white"
d = 7
n = 200
blank_prop = 0.05
by = 0.5
d_blank = d * blank_prop
n_m = 300
n_l = 150
n_r = 150
letter_ratio_m = 8
letter_ratio_l = 8
letter_ratio_r = 8
alpha = 0.3


square = expand.grid(
  x = seq(0, 7 - by, by = by),
  y = seq(0, 7 - by, by = by)
)

point2edges = function(x, y) {
  data.table(
    x = c(x, x, x + by, x + by),
    y = c(y, y + by, y + by, y)
  )
}

shrink = function(data, eps) {
  x_new = data[["x"]]
  x_upper = max(x_new) - eps
  x_lower = min(x_new) + eps
  y_new = data[["y"]]
  y_upper = max(y_new) - eps
  y_lower = min(y_new) + eps
  data.table(
    x = c(x_lower, x_lower, x_upper, x_upper),
    y = c(y_lower, y_upper, y_upper, y_lower)
  )
}

shift_x = function(data, d_x) {
  data = copy(data)
  data[, x := x + d_x]
  return(data)
}

shift_x_squares = function(data_list, d_x) {
  map(data_list, function(data) shift_x(data, d_x))
}

d_xs = 0:2 * 7 * (1 + blank_prop)

squares = pmap(square, point2edges)
squares = map(squares, function(data) shrink(data, by * shrink_prop))
squares_list = map(d_xs, function(d_x) shift_x_squares(squares, d_x))



contained = function(x, y, x_range, y_range) {
  x_range[[1]] <= x && x <= x_range[[2]] &&
    y_range[[1]] <= y && y <= y_range[[2]]
}

in_m = function(data, shift = 0) {
  x = mean(data[["x"]]) - shift
  y = mean(data[["y"]])

  if (contained(x, y, c(1, 2), c(0, 5))) return(TRUE)
  if (contained(x, y, c(1, 6), c(4, 5))) return(TRUE)
  if (contained(x, y, c(3, 4), c(2, 5))) return(TRUE)
  if (contained(x, y, c(5, 6), c(0, 5))) return(TRUE)
  return(FALSE)
}

in_l = function(data, shift = 0) {
  x = mean(data[["x"]]) - shift
  y = mean(data[["y"]])
  if (contained(x, y, c(2, 5), c(0, 1))) return(TRUE)
  if (contained(x, y, c(2, 3), c(0, 5))) return(TRUE)
  return(FALSE)
}

in_r = function(data, shift = 0) {
  x = mean(data[["x"]]) - shift
  y = mean(data[["y"]])
  if (contained(x, y, c(2, 3), c(0, 5))) return(TRUE)
  if (contained(x, y, c(2, 5), c(4, 5))) return(TRUE)
    return(FALSE)
}



sample_ids = function(letter, letter_ratio, n) {
  in_letter = switch(letter,
    m = in_m,
    l = in_l,
    r = in_r
  )
  letter_ids = which(map_lgl(
    seq(nrow(square)),
    function(i) in_letter(square[i, ])
    ))
  outside_ids = setdiff(seq(nrow(square)), letter_ids)
  prop_outside = length(outside_ids) / nrow(square)
  prop_letter = (1 - prop_outside)
  p_letter = (prop_letter * letter_ratio) /
    (prop_letter * letter_ratio + prop_outside)
  n_letter = p_letter * n
  n_outside = n - n_letter
  ids = c(
    sample(letter_ids, size = n_letter, replace = TRUE),
    sample(outside_ids, size = n_outside, replace = TRUE)
  )
  return(ids)
}
m_ids = sample_ids("m", letter_ratio_m, n_m)
l_ids = sample_ids("l", letter_ratio_l, n_l)
r_ids = sample_ids("r", letter_ratio_r, n_r)

plot = ggplot() +
  coord_cartesian(xlim = c(0, 21 + 2 * 7 * blank_prop), ylim = c(0, 7)) +
  theme_void()

for (i in 1:3) {
  if (i == 1) test_ids = m_ids
  if (i == 2) test_ids = l_ids
  if (i == 3) test_ids = r_ids
  data = squares_list[[i]]
  for (j in seq(length(data))) {
    if (j %in% test_ids) {
      color = colors[[i]]
      alpha_current = alpha * sum(test_ids == j)
      # plot = plot +
      #   geom_polygon(data = data[[j]], aes(x = x, y = y), alpha = alpha, fill = color)
      color = colors[[i]]
      alpha_current = alpha * sum(test_ids == j)
    } else {
      color = grey_light
      alpha_current = 0.2
    }
    plot = plot +
      geom_polygon(data = data[[j]], aes(x = x, y = y), alpha = alpha_current, fill = color)
  }
}

print(plot)

ggsave("~/mlr/mlr-org-website/assets/banner.png", plot)

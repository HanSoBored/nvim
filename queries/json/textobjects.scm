(comment) @comment.outer

; JSON tidak punya node "function" — petakan @function.* ke blok object {…}
; supaya vaf/vif berfungsi di file .json (konvensi sama dengan query C bawaan plugin)
(object) @function.outer

(object
  "{"
  _+ @function.inner
  "}")

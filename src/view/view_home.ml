open Tea.Html
module Internal = View_internal

let view =
  let item link = li [] [link] in
  let open Internal in
  nav []
    [ul [] [item home_link; item speaking_link; item dictation_link; item settings_link]]

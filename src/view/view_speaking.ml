open Tea.Html
module Internal = View_internal

let view model =
  div []
    [ Internal.home_link
    ; input' [type' "text"; onChange speaking] []
    ; (text @@ match model.speaking with Some msg -> msg | None -> "empty") ]

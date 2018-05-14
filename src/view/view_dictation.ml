open Tea.Html
module Internal = View_internal

let view model =
  div []
    [ Internal.home_link
    ; input' [type' "text"; onChange dictation] []
    ; (text @@ match model.dictation with Some msg -> msg | None -> "empty") ]

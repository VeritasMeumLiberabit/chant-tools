let ast = Chant_tools.Hymn.parse_text {|First|Line
second line

Second Verse

1|2|3 1 |}

let () =
  match ast with
  | Ok ast -> Format.printf "%s" (Chant_tools.Hymn.text_to_string ast)
  | Error error -> Format.printf "%s" error

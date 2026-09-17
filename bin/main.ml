let ast = Chant_tools.Hymn.parse_text "\nFirst|Line\nsecond line\n\nSecond Verse\n\n1|2|3 1|2|3|4|5"

let () = match ast with
| Ok ast -> Format.printf "%s" (Chant_tools.Hymn.text_to_string ast)
| Error error -> Format.printf "%s" error

module Arg = Cmdliner.Arg
module Cmd = Cmdliner.Cmd
module Manpage = Cmdliner.Manpage
open Cmdliner.Term.Syntax

let read_file filename =
  let input = In_channel.open_text filename in
  let contents = In_channel.input_all input in
  In_channel.close input ; contents

let parse_hymn filename =
  let file = read_file filename in
  let file = String.trim file in
  Chant_tools.Hymn.parse_text (Some filename) file

let print_result filename =
  let ghymn = parse_hymn filename in
  match ghymn with
  | Ok ast -> Format.printf "%s" (Chant_tools.Hymn.text_to_string ast)
  | Error error -> Format.printf "%s" error

(* Command line parsing below *)

let hymn_file = Arg.(value & pos 0 filepath "" & info [])

let cmd =
  let doc = "Hymn tool" in
  let man = [`S Manpage.s_bugs; `P "Email bugs reports to <me@jonathanlowe.dev>."] in
  (* TODO -- Inject the name of the command line utility and version from dune *)
  Cmd.make (Cmd.info "hymn" ~version:"%%VERSION%%" ~doc ~man)
  @@
  let+ hymn_file in
  print_result hymn_file

let _ = exit (Cmd.eval cmd)

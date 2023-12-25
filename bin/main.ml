let () =
  let open Nixy.Stat in
  match access "/Users/taz/.cargo/bin/cargo" ~flag:`X_OK with
  | Ok x -> Format.printf "%d\n" x
  | Error s -> Format.print_string s
;;

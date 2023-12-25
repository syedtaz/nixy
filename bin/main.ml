let () =
  let open Nixy.Stat in
  Format.print_int @@ access "/Users/taz/.cargo/bin/cargo" ~flag:`X_OK

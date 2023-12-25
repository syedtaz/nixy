open Ctypes
open Foreign

module Flags = struct
  type access =
    [ `F_OK
    | `R_OK
    | `W_OK
    | `X_OK
    ]

  let bits_of_access = function
    | `F_OK -> 0
    | `R_OK -> 4
    | `W_OK -> 2
    | `X_OK -> 1
  ;;
end

module C = struct
  let access = foreign ~check_errno:true "access" (ptr char @-> int @-> returning int)
end

let access path ~flag =
  let p = CArray.start @@ CArray.of_string path in
  C.access p (Flags.bits_of_access flag)
;;

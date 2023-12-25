open Ctypes
open Foreign

type errno =
  [ `EACCES
  | `ELOOP
  | `ENAMETOOLONG
  | `ENOENT
  | `ENOTDIR
  | `EROFS
  ]

let int_of_errno = function
  | `EACCES -> 13
  | `ELOOP -> 62
  | `ENAMETOOLONG -> 63
  | `ENOENT -> 2
  | `ENOTDIR -> 20
  | `EROFS -> 30
;;

let check = foreign "strerror" (int @-> returning (ptr char))

let result (f : unit -> 'a) =
  try Ok (f ()) with
  | Unix.Unix_error (err, _, _) -> Error (Unix.error_message err)
;;

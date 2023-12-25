open Ctypes
open Foreign
open Utils

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
  let getpid = foreign ~check_errno:true "getpid" (void @-> returning int) [@@noalloc]
  let getppid = foreign ~check_errno:true "getppid" (void @-> returning int) [@@noalloc]
  let setpgid = foreign ~check_errno:true "setpgid" (int @-> int @-> returning int)
end

let access path ~flag =
  Errno.result (fun () ->
    C.access (CArray.start @@ CArray.of_string path) (Flags.bits_of_access flag))
;;

module Pid = struct
  type t = [`Self | `Pid of int]

  let of_int x = `Pid x
end

(** The [getpid] function shall return the process ID of the calling process.
    The getpid() function shall always be successful and no return value is
    reserved to indicate an error.*)
let getpid () = C.getpid () |> Pid.of_int |> Result.ok

(** The [getppid] function shall return the parent process ID of the calling
    process. The getppid function shall always be successful and no return value
    is reserved to indicate an error.*)
let getppid () = C.getppid () |> Pid.of_int |> Result.ok

(** The [setpgid] function shall either join an existing process group or create
    a new process group within the session of the calling process. The process
    group ID of a session leader shall not change. Upon successful completion,
    the process group ID of the process with a process ID that matches pid shall
    be set to pgid. *)
let setpgid pid pgid = Errno.result (fun () -> C.setpgid pid pgid)

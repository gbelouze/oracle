module V = struct
  type t = string

  let compare = String.compare

  let encode_sz = 15

  let encode s =
    assert (String.length s = encode_sz);
    s

  let decode = encode
end

module H = struct
  let ram = 10_000

  let kway = 30
end

module Sort = Oracle.Make (V) (H)

let () = Printexc.record_backtrace true

let () = Random.init 42

let random_char _seed = char_of_int (33 + Random.int 94)

let random_v () = String.init (V.encode_sz - 1) random_char ^ "\n"

let run n =
  let oracle = random_v in
  let root = "test_progress" in
  if not (Sys.file_exists root) then Unix.mkdir root 0o777;
  let out = root ^ "/" ^ "out" in
  Sort.sort ~with_prog:true ~oracle ~out n

let () = run 1_000_000

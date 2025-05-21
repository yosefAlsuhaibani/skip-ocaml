let () =
  Reactive.init "cache.rheap" (1024 * 1024 * 1024);  (* 1 GB heap *)
  let files = [| "/tmp/input1.txt"; "/tmp/input2.txt" |] in
  let inputs = Reactive.input_files files in
  let contents =
    Reactive.map inputs (fun key trackers ->
      print_endline key;
      let content = Reactive.read_file key (Array.get trackers 0) in
      [| (key ^ "-content", [| content |]) |]
    )
  in
  let lengths =
    Reactive.map contents (fun key contents ->
      print_endline key;
      let length = String.length (Array.get contents 0) in
      [| (key ^ "-length", [| length |]) |]
    )
  in
  Reactive.exit ();
  files |> Array.iter (fun file ->
    let length = (Reactive.get_array lengths (file ^ "-content-length")).(0) in
    print_endline (Printf.sprintf "%s: %d" file length)
  );
  ()

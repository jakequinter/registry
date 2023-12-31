open Lwt.Syntax
open Models.Guest

let row req pool =
  let open Dream_html in
  let open HTML in
  let* guest = get_guest req pool in
  Lwt.return
    (tr
       []
       [ td
           [ class_
               "whitespace-nowrap px-3 py-4 text-sm text-gray-900 font-bold"
           ]
           [ txt "%s" guest.name ]
       ; td
           [ class_ " px-3 py-4 text-sm text-gray-500" ]
           [ txt "%s" guest.address ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ input [ name "amount"; value "%i" guest.amount ] ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ input
               ([ type_ "checkbox"; name "rsvp"; value "1" ]
                @ if guest.rsvp then [ checked ] else [])
           ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ input
               ([ type_ "checkbox"; name "invite_sent"; value "1" ]
                @ if guest.invite_sent then [ checked ] else [])
           ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ input
               ([ type_ "checkbox"; name "save_the_date"; value "1" ]
                @ if guest.save_the_date then [ checked ] else [])
           ]
       ; td
           [ class_ "whitespace-nowrap px-3 py-4 text-sm text-gray-500" ]
           [ button
               [ Hx.put "/guests/%i" guest.id
               ; Hx.include_ "closest tr"
               ; class_
                   "rounded bg-gray-100 px-2 py-1 text-xs font-semibold \
                    text-black shadow-sm hover:bg-gray-200 \
                    focus-visible:outline focus-visible:outline-2 \
                    focus-visible:outline-offset-2 \
                    focus-visible:outline-gray-100"
               ]
               [ txt "Cancel" ]
           ; button
               [ Hx.put "/guests/%i" guest.id
               ; Hx.include_ "closest tr"
               ; class_
                   "rounded bg-gray-900 px-2 py-1 text-xs font-semibold \
                    text-white shadow-sm hover:bg-opacity-90 \
                    focus-visible:outline focus-visible:outline-2 \
                    focus-visible:outline-offset-2 \
                    focus-visible:outline-gray-900"
               ]
               [ txt "Save" ]
           ]
       ])
;;

let handler req pool =
  let* response_content = row req pool in
  Dream_html.respond
    ~status:`OK
    ~headers:[ "Content-Type", "text/html" ]
    response_content
;;

let edit_row_routes pool =
  [ Dream.get "/guests/:id/edit" (fun req -> handler req pool) ]
;;

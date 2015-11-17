import Debug exposing (log)
import Effects exposing (Effects, Never)
import Html
import Html.Attributes as Attr
import Signal exposing (Address)
import StartApp
import Task

import Jenkins


type Action
    = Nothing
    | ReadJob (Maybe Jenkins.Job)
    | ReadAvailableJobs Jenkins.AvailableJobsResult

type alias Model =
    { availableJobs: List Jenkins.JobStub
    , monitoredJobs: List Jenkins.Job
    }

readAvailableJobs =
    Jenkins.readAvailableJobs
        |> Task.map ReadAvailableJobs
        |> Effects.task

init : (Model, Effects Action)
init =
    ( { availableJobs = []
      , monitoredJobs = []
      }
    , readAvailableJobs
    --, Effects.none
    )

update : Action -> Model -> (Model, Effects Action)
update action model =
    log "update" (case action of
        ReadAvailableJobs (Ok jobs) ->
            ( { model |
                availableJobs <- jobs
              }
            , Effects.none
            )
    )

mdlCell content =
    Html.div
        [ Attr.class "mdl-cell mdl-cell--12-col"
        ]
        [ content ]

view : Address Action -> Model -> Html.Html
view address model = Html.div
    []
    [ Html.div
        [ Attr.class "mdl-grid jjm-page-container"
        ]
        (List.map (mdlCell << viewJobStub address) model.availableJobs)
    ]

viewJobStub : Address Action -> Jenkins.JobStub -> Html.Html
viewJobStub address jobStub =
    Html.div
        [ Attr.class "mdl-shadow--2dp jjm-card"
        ]
        [ Html.text jobStub.name
        ]

app =
    StartApp.start
        { init = init
        , update = update
        , view = view
        , inputs = []
        }

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

main = app.html

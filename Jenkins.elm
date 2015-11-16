module Jenkins where

import Effects
import Http
import Json.Decode exposing ((:=))
import Result
import Task


type alias JobStub =
    { name: String
    , color: String
    }

type alias Job =
    { name: String
    , color: String
    }

type alias AvailableJobsResult =
    Result Http.Error (List JobStub)

type alias JobResult =
    Result Http.Error Job


readAvailableJobs : Task.Task Effects.Never AvailableJobsResult
readAvailableJobs =
    getUrl "" []
        |> Http.get decodeStubs
        |> Task.toResult

{--
readJob : Task.Task Effects.Never JobResult
readJob =
    getUrl "" []
        |> Http.get decodeStubs
        |> Task.toResult
--}

getUrl : String -> List (String, String) -> String
getUrl resource query =
    Http.url ("/external/jenkins/" ++ resource ++ "api/json") query

decodeStub = Json.Decode.object2 JobStub
    ("name" := Json.Decode.string)
    ("color" := Json.Decode.string)

decodeStubs =
    "jobs" := Json.Decode.list decodeStub

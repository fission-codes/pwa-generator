module Components.ManifestEditor exposing (ManifestEditor, init)

import Element exposing (..)
import Manifest exposing (Manifest)


type ManifestEditor
    = ManifestEditor Internals


type alias Internals =
    { manifest : Manifest
    , device : Device
    }



-- API


init :
    { manifest : Manifest
    , device : Device
    }
    -> ManifestEditor
init options =
    ManifestEditor
        { manifest = options.manifest
        , device = options.device
        }



-- INTERNAL ACCESS


internalManifest : ManifestEditor -> Manifest
internalManifest (ManifestEditor internals) =
    internals.manifest


internalDevice : ManifestEditor -> DeviceClass
internalDevice (ManifestEditor internals) =
    internals.device.class



-- UPDATE


mapManifest : (Manifest -> Manifest) -> ManifestEditor -> ManifestEditor
mapManifest transform (ManifestEditor internals) =
    ManifestEditor { internals | manifest = transform internals.manifest }


mapDevice : (Device -> Device) -> ManifestEditor -> ManifestEditor
mapDevice transform (ManifestEditor internals) =
    ManifestEditor { internals | device = transform internals.device }



-- VIEW


view :
    { manifestEditor : ManifestEditor
    , onUpdateManifestEditor : ManifestEditor -> msg
    }
    -> Element msg
view options =
    row []
        [ viewManifestForm
            { manifestEditor = options.manifestEditor }
        , viewManifestOutputs (internalManifest options.manifestEditor)
        ]


viewManifestForm : { manifestEditor : ManifestEditor } -> Element msg
viewManifestForm options =
    column [] []


viewManifestOutputs : Manifest -> Element msg
viewManifestOutputs mnfst =
    column [] []

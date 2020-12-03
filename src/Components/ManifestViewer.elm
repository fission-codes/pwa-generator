module Components.ManifestViewer exposing (ManifestViewer, init)

import Element exposing (..)
import Manifest exposing (Manifest)


type ManifestViewer
    = ManifestViewer Internals


type alias Internals =
    { manifest : Manifest
    , device : Device
    }



-- API


init :
    { manifest : Manifest
    , device : Device
    }
    -> ManifestViewer
init options =
    ManifestViewer
        { manifest = options.manifest
        , device = options.device
        }



-- INTERNAL ACCESS


internalManifest : ManifestViewer -> Manifest
internalManifest (ManifestViewer internals) =
    internals.manifest


internalDevice : ManifestViewer -> DeviceClass
internalDevice (ManifestViewer internals) =
    internals.device.class



-- UPDATE


mapManifest : (Manifest -> Manifest) -> ManifestViewer -> ManifestViewer
mapManifest transform (ManifestViewer internals) =
    ManifestViewer { internals | manifest = transform internals.manifest }


mapDevice : (Device -> Device) -> ManifestViewer -> ManifestViewer
mapDevice transform (ManifestViewer internals) =
    ManifestViewer { internals | device = transform internals.device }



-- VIEW


view :
    { manifestViewer : ManifestViewer
    , onUpdateManifestViewer : ManifestViewer -> msg
    }
    -> Element msg
view options =
    row []
        [ viewManifest
            { manifest = internalManifest options.manifestViewer }
        ]


viewManifest : { manifest : Manifest } -> Element msg
viewManifest options =
    column [] []

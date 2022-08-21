// Package whistle provides details for the Whistle applet.
package whistle

import (
	_ "embed"

	"tidbyt.dev/community/apps/manifest"
)

//go:embed whistle.star
var source []byte

// New creates a new instance of the Whistle applet.
func New() manifest.Manifest {
	return manifest.Manifest{
		ID:          "whistle",
		Name:        "Whistle",
		Author:      "nshenkman",
		Summary:     "Pet activity tracker",
		Desc:        "Connects to Whistle APIs to get latest daily data of your pet.",
		FileName:    "whistle.star",
		PackageName: "whistle",
		Source:  source,
	}
}

fs   = require('fs')
path = require('path')

class ImageFiles
  @imageDir: path.join(__dirname, '..', '.generated', 'img')

  @dirFor: (type) =>
    if type then path.join(@imageDir, type) else @imageDir

  @allNames: (type) =>
    fs.readdirSync(@dirFor(type))
      .filter (imageFileName) ->
        imageFileName.match(/\.png/)
      .map (imageFileName) ->
        imageFileName.replace(/\.png/, '')

  @allPaths: (type) =>
    dir = @dirFor(type)

    @allNames(type).map (name) =>
      path.join(dir, "#{name}.png")

  @pathFor: (type, fileName) =>
    path.join(@dirFor(type), "#{fileName}.png")

module.exports = ImageFiles

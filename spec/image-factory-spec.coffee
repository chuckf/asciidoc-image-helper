fs = require 'fs'
path = require 'path'
temp = require('temp').track()
imageFactory = require '../lib/image-factory'

describe 'Image factory', ->

  rootDirectory = null

  describe 'createDirectory should', ->

    rootDirectory = null

    beforeEach ->
      rootDirectory = temp.mkdirSync()

    it 'return directory path if directory already exists', ->
      result = null
      directory = path.join rootDirectory, 'imagesFolder'
      fs.mkdirSync directory

      waitsForPromise ->
        imageFactory.createDirectory(rootDirectory, 'imagesFolder').then (r) -> result = r

      runs ->
        expect(result).toBe directory
        expect(result).toMatch /^.*imagesFolder$/

    it 'create directory and his path if directory doesn\'t exist', ->
      result = null
      rootDirectory = temp.mkdirSync()

      waitsForPromise ->
        imageFactory.createDirectory(rootDirectory, 'imagesFolder').then (r) -> result = r

      runs ->
        expect(result).toBe path.join rootDirectory, 'imagesFolder'
        expect(result).toMatch /^.*imagesFolder$/

  describe 'createDirectory should', ->

    rootDirectory = null

    beforeEach ->
      rootDirectory = temp.mkdirSync()

    it 'create a file when image has a valid name', ->
      result = null
      imagePath = path.join rootDirectory, 'fake.png'
      buffer = 'fake content'

      waitsForPromise ->
        imageFactory.writeImage(imagePath, buffer).then (r) -> result = r

      runs ->
        expect(result).toMatch /^.*fake.png$/

    it 'thrown an error when image have a same name as a folder', ->
      error = null
      directory = path.join rootDirectory, 'fake'
      fs.mkdirSync directory
      imagePath = path.join rootDirectory, 'fake'
      buffer = 'fake content'

      waitsForPromise ->
        imageFactory.writeImage(imagePath, buffer).catch (r) -> error = r

      runs ->
        expect(error.errno).toBe -21
        expect(error.code).toBe 'EISDIR'
        expect(error.syscall).toBe 'open'

  describe 'createDirectory should', ->

    it 'create a random image name when current file have an extension', ->
      currentFileName = '/tmp/test/myfile.adoc'
      buffer = 'fake content'
      imageName = imageFactory.createImageName currentFileName, buffer

      expect(imageName).toMatch /^\/tmp\/test\/myfile-\w+.png$/

    it 'create a random image name when current file does\'t have an extension', ->
      currentFileName = '/tmp/test/myfile'
      buffer = 'fake content'
      imageName = imageFactory.createImageName currentFileName, buffer

      expect(imageName).toMatch /^\/tmp\/test\/myfile-\w+.png$/

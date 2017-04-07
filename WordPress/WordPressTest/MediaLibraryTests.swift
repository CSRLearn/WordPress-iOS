import XCTest
@testable import WordPress

class MediaServiceTests: XCTestCase {

    func testThatLocalMediaDirectoryIsAvailable() {
        do {
            let url = try MediaService.localMediaDirectory()
            XCTAssertTrue(url.lastPathComponent == "Media", "Error: local media directory is not named Media, as expected.")
        } catch {
            XCTFail("Error accessing or creating local media directory: \(error)")
        }
    }

    func testThatLocalMediaURLWorks() {
        do {
            let basename = "media-service-test-sample"
            let pathExtension = "jpg"
            let expected = "\(basename).\(pathExtension)"
            var url = try MediaService.makeLocalMediaURL(with: basename, fileExtension: pathExtension)
            XCTAssertTrue(url.lastPathComponent == expected, "Error: local media url have unexpected filename or extension: \(url)")
            url = try MediaService.makeLocalMediaURL(with: expected, fileExtension: pathExtension)
            XCTAssertTrue(url.lastPathComponent == expected, "Error: local media url have unexpected filename or extension: \(url)")
            url = try MediaService.makeLocalMediaURL(with: basename + ".png", fileExtension: pathExtension)
            XCTAssertTrue(url.lastPathComponent == expected, "Error: local media url have unexpected filename or extension: \(url)")
        } catch {
            XCTFail("Error creating local media URL: \(error)")
        }
    }

    func testThatMediaThumbnailFilenameWorks() {
        let basename = "media-service-test-sample"
        let pathExtension = "jpg"
        var thumbnail = MediaService.mediaFilenameAppendingThumbnail("\(basename).\(pathExtension)")
        XCTAssertTrue(thumbnail == "\(basename)-thumbnail.\(pathExtension)", "Error: appending media thumbnail to filename returned unexpected result.")
        thumbnail = MediaService.mediaFilenameAppendingThumbnail(basename)
        XCTAssertTrue(thumbnail == "\(basename)-thumbnail", "Error: appending media thumbnail to filename returned unexpected result.")
    }

    func testThatSizeForMediaImageAtFileURLWorks() {
        var mediaPath = OHPathForFile("test-image.jpg", type(of: self))
        var size = MediaService.imageSizeForMediaAt(fileURL: URL(fileURLWithPath: mediaPath!))
        XCTAssertTrue(size == CGSize(width: 1024, height: 680), "Unexpected size returned when testing imageSizeForMediaAtPath.")

        // Test an image in portrait orientation, example is in EXIF Orientation: 5
        mediaPath = OHPathForFile("test-image-portrait.jpg", type(of: self))
        // Check that size matches for the expected default orientation
        size = MediaService.imageSizeForMediaAt(fileURL: URL(fileURLWithPath: mediaPath!))
        XCTAssertTrue(size == CGSize(width: 1024, height: 680), "Unexpected size returned when testing an image with an exif orientation of 5 via imageSizeForMediaAtPath.")
    }

    func testThatClearingUnusedFilesFromLocalMediaDirectoryWorks() {
        let expect = self.expectation(description: "cleaned unnused files from media directory")
        MediaService.clearUnusedFilesFromLocalMediaDirectory(onCompletion: {
            // Ideally we would verify that the local media directory was indeed cleaned.
            // However, for now we're just looking to make sure there aren't any errors being thrown with the implementation.
            expect.fulfill()
        }) { (error) in
            expect.fulfill()
            XCTFail("Failed cleaning unused local media directory files with error: \(error.localizedDescription)")
        }
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }

    func testThatClearingCachedFilesFromLocalMediaDirectoryWorks() {
        let expect = self.expectation(description: "cleaned media directory")
        MediaService.clearCachedFilesFromLocalMediaDirectory(onCompletion: {
            // Ideally we would verify that the local media directory was indeed cleaned.
            // However, for now we're just looking to make sure there aren't any errors being thrown with the implementation.
            expect.fulfill()
        }) { (error) in
            expect.fulfill()
            XCTFail("Failed cleaning local media directory with error: \(error.localizedDescription)")
        }
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
}

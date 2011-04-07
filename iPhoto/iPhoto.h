/*
 * iPhoto.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class iPhotoItem, iPhotoApplication, iPhotoColor, iPhotoDocument, iPhotoWindow, iPhotoAttributeRun, iPhotoCharacter, iPhotoParagraph, iPhotoText, iPhotoAttachment, iPhotoWord, iPhotoAlbum, iPhotoApplication, iPhotoKeyword, iPhotoPhoto, iPhotoPrintSettings;

typedef enum {
	iPhotoSavoAsk = 'ask ' /* Ask the user whether or not to save the file. */,
	iPhotoSavoNo = 'no  ' /* Do not save the file. */,
	iPhotoSavoYes = 'yes ' /* Save the file. */
} iPhotoSavo;

typedef enum {
	iPhotoViewEdit = 'edit' /* edit */,
	iPhotoViewEvents = 'evts' /* events */,
	iPhotoViewOrganize = 'orga' /* organize */
} iPhotoView;

typedef enum {
	iPhotoAlTyBookAlbum = 'book' /* book album */,
	iPhotoAlTyEventsAlbum = 'eval' /* Album containing all the events in a library. */,
	iPhotoAlTyFacesAlbum = 'faal' /* Album containing all the faces in a library. */,
	iPhotoAlTyFlaggedAlbum = 'flal' /* Album containing all the flagged photos in a library. */,
	iPhotoAlTyFolderAlbum = 'fldr' /* folder album */,
	iPhotoAlTyLastImportAlbum = 'lstI' /* last import album */,
	iPhotoAlTyLastMonthsAlbum = 'lstM' /* last months album */,
	iPhotoAlTyLastRollsAlbum = 'lstR' /* last rolls album, but please use last import album now */,
	iPhotoAlTyPhotoLibraryAlbum = 'aral' /* Album containing all the photos in a library. */,
	iPhotoAlTyPlacesAlbum = 'plal' /* Album containing all the places in a library. */,
	iPhotoAlTyPublishedAlbum = 'pubs' /* published album */,
	iPhotoAlTyRegularAlbum = 'albm' /* regular album */,
	iPhotoAlTySharedAlbum = 'papa' /* album of a shared library */,
	iPhotoAlTySharedLibrary = 'papl' /* shared library; contains one or more children, which are shared albums */,
	iPhotoAlTySlideshowAlbum = 'slds' /* slideshow album */,
	iPhotoAlTySmartAlbum = 'smrt' /* smart album */,
	iPhotoAlTySubscribedAlbum = 'subs' /* subscribed album */,
	iPhotoAlTyTrashAlbum = 'tral' /* trash album */,
	iPhotoAlTyUnknownAlbumType = 'aluk' /* unknown album type */
} iPhotoAlTy;

typedef enum {
	iPhotoEnumStandard = 'lwst' /* Standard PostScript error handling */,
	iPhotoEnumDetailed = 'lwdt' /* print a detailed report of PostScript errors */
} iPhotoEnum;



/*
 * Standard Suite
 */

// A scriptable object.
@interface iPhotoItem : SBObject

@property (copy) NSDictionary *properties;  // All of the object's properties.

- (void) closeSaving:(iPhotoSavo)saving savingIn:(NSURL *)savingIn;  // Close an object.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (BOOL) exists;  // Verify if an object exists.
- (void) moveTo:(SBObject *)to;  // Move object(s) to a new location.
- (void) saveAs:(NSString *)as in:(NSURL *)in_;  // Save an object.
- (void) addTo:(id)to;  // Add the given object to the container.
- (void) assignKeywordString:(NSString *)string;  // Assign an existing keyword to the currently-selected photos.
- (void) autoImport;  // Start importing photos from the auto-import folder.
- (void) duplicateTo:(id)to;  // Create a duplicate of an object.
- (void) emptyTrash;  // Empty the Trash album.
- (void) importFrom:(NSString *)from forceCopy:(NSInteger)forceCopy to:(iPhotoAlbum *)to;  // Import the given path.
- (iPhotoAlbum *) newAlbumName:(NSString *)name;  // Create a new album.
- (void) nextSlide;  // Skip to previous slide in currently-playing slideshow.
- (void) pauseSlideshow;  // Pause the currently-playing slideshow.
- (void) previousSlide;  // Skip to next slide in currently-playing slideshow.
- (void) removeFrom:(id)from;  // Remove the given object from its container.
- (void) resumeSlideshow;  // Resume the currently-playing slideshow.
- (void) reverseGeocode;  // Call after setting a photo's latitude and longitude.  This command instructs iPhoto to use lat/lon to look up the country, city, point of interest, etc.
- (void) select;  // Select one or more objects.
- (void) startSlideshowAsynchronous:(NSInteger)asynchronous displayIndex:(NSInteger)displayIndex iChat:(NSInteger)iChat usingAlbum:(NSString *)usingAlbum;  // Display a slideshow with the currently-selected photos or album.
- (void) stopSlideshow;  // End the currently-playing slideshow.

@end

// An application's top level scripting object.
@interface iPhotoApplication : SBApplication

- (SBElementArray *) documents;
- (SBElementArray *) windows;

@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *name;  // The name of the application.
@property (copy, readonly) NSString *version;  // The version of the application.

- (iPhotoDocument *) open:(NSURL *)x;  // Open an object.
- (void) print:(NSURL *)x printDialog:(BOOL)printDialog withProperties:(iPhotoPrintSettings *)withProperties;  // Print an object.
- (void) quitSaving:(iPhotoSavo)saving;  // Quit an application.

@end

// A color.
@interface iPhotoColor : iPhotoItem


@end

// A document.
@interface iPhotoDocument : iPhotoItem

@property (readonly) BOOL modified;  // Has the document been modified since the last save?
@property (copy) NSString *name;  // The document's name.
@property (copy) NSString *path;  // The document's path.


@end

// A window.
@interface iPhotoWindow : iPhotoItem

@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Whether the window has a close box.
@property (copy, readonly) iPhotoDocument *document;  // The document whose contents are being displayed in the window.
@property (readonly) BOOL floating;  // Whether the window floats.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property (readonly) BOOL miniaturizable;  // Whether the window can be miniaturized.
@property BOOL miniaturized;  // Whether the window is currently miniaturized.
@property (readonly) BOOL modal;  // Whether the window is the application's current modal window.
@property (copy) NSString *name;  // The full title of the window.
@property (readonly) BOOL resizable;  // Whether the window can be resized.
@property (readonly) BOOL titled;  // Whether the window has a title bar.
@property BOOL visible;  // Whether the window is currently visible.
@property (readonly) BOOL zoomable;  // Whether the window can be zoomed.
@property BOOL zoomed;  // Whether the window is currently zoomed.


@end



/*
 * Text Suite
 */

// This subdivides the text into chunks that all have the same attributes.
@interface iPhotoAttributeRun : iPhotoItem

- (SBElementArray *) attachments;
- (SBElementArray *) attributeRuns;
- (SBElementArray *) characters;
- (SBElementArray *) paragraphs;
- (SBElementArray *) words;

@property (copy) NSColor *color;  // The color of the first character.
@property (copy) NSString *font;  // The name of the font of the first character.
@property NSInteger size;  // The size in points of the first character.


@end

// This subdivides the text into characters.
@interface iPhotoCharacter : iPhotoItem

- (SBElementArray *) attachments;
- (SBElementArray *) attributeRuns;
- (SBElementArray *) characters;
- (SBElementArray *) paragraphs;
- (SBElementArray *) words;

@property (copy) NSColor *color;  // The color of the first character.
@property (copy) NSString *font;  // The name of the font of the first character.
@property NSInteger size;  // The size in points of the first character.


@end

// This subdivides the text into paragraphs.
@interface iPhotoParagraph : iPhotoItem

- (SBElementArray *) attachments;
- (SBElementArray *) attributeRuns;
- (SBElementArray *) characters;
- (SBElementArray *) paragraphs;
- (SBElementArray *) words;

@property (copy) NSColor *color;  // The color of the first character.
@property (copy) NSString *font;  // The name of the font of the first character.
@property NSInteger size;  // The size in points of the first character.


@end

// Rich (styled) text
@interface iPhotoText : iPhotoItem

- (SBElementArray *) attachments;
- (SBElementArray *) attributeRuns;
- (SBElementArray *) characters;
- (SBElementArray *) paragraphs;
- (SBElementArray *) words;

@property (copy) NSColor *color;  // The color of the first character.
@property (copy) NSString *font;  // The name of the font of the first character.
@property NSInteger size;  // The size in points of the first character.


@end

// Represents an inline text attachment.  This class is used mainly for make commands.
@interface iPhotoAttachment : iPhotoText

@property (copy) NSString *fileName;  // The path to the file for the attachment


@end

// This subdivides the text into words.
@interface iPhotoWord : iPhotoItem

- (SBElementArray *) attachments;
- (SBElementArray *) attributeRuns;
- (SBElementArray *) characters;
- (SBElementArray *) paragraphs;
- (SBElementArray *) words;

@property (copy) NSColor *color;  // The color of the first character.
@property (copy) NSString *font;  // The name of the font of the first character.
@property NSInteger size;  // The size in points of the first character.


@end



/*
 * iPhoto suite
 */

// An album.  This abstract class represents the albums within an iPhoto library.
@interface iPhotoAlbum : iPhotoItem

- (SBElementArray *) keywords;
- (SBElementArray *) photos;

@property (copy, readonly) NSArray *children;  // Array of album's children albums in the library hierarchy.
- (NSInteger) id;  // The unique ID of the album.
@property (copy) NSString *name;  // The name of the album.
@property (copy, readonly) iPhotoAlbum *parent;  // Album's parent in the library hierarchy.
@property (readonly) iPhotoAlTy type;  // Type of album.
@property (copy, readonly) NSString *url;  // URL of published/subscribed album.


@end

// iPhoto's top level scripting object.
@interface iPhotoApplication (IPhotoSuite)

- (SBElementArray *) albums;
- (SBElementArray *) keywords;
- (SBElementArray *) photos;

@property (copy) iPhotoAlbum *currentAlbum;  // The selected album.
@property (copy, readonly) iPhotoAlbum *eventsAlbum;  // Events album.
@property (copy, readonly) iPhotoAlbum *facesAlbum;  // Faces album.
@property (copy, readonly) iPhotoAlbum *flaggedAlbum;  // Flagged photos album.
@property (readonly) NSInteger importing;  // Returns true if photo importing is in progress.
@property (copy, readonly) iPhotoAlbum *lastImportAlbum;  // Last import album.
@property (copy, readonly) iPhotoAlbum *lastMonthsAlbum;  // The set of N most recently imported month(s) of photos.  N is based on the preference set in iPhoto.
@property (copy, readonly) iPhotoAlbum *lastRollsAlbum;  // Now obsolete;  please use last import album.  Old: The set of N most recently imported roll(s) of photos.  N is based on the preference set in iPhoto.
@property (copy, readonly) NSArray *localRootAlbums;  // Returns local albums that are at the root level in the source view.
@property (copy) NSString *mailAddress;  // The address for the e-mail.
@property (copy) NSString *mailRecipient;  // The recipient for the e-mail.
@property (copy) NSString *mailSubject;  // The subject for the e-mail.
@property (copy, readonly) iPhotoAlbum *photoLibraryAlbum;  // The photo library.
@property (copy, readonly) iPhotoAlbum *placesAlbum;  // Places album.
@property (copy) NSArray *selection;  // The current selection.
@property (copy, readonly) NSArray *sharedLibraryAlbums;  // Returns shared libraries from other computers on the network.
@property (readonly) NSInteger slideshowRunning;  // Returns true if a slideshow is currently running.
@property (copy, readonly) iPhotoAlbum *trashAlbum;  // The set of deleted photos.
@property iPhotoView view;  // The current view in the application.

@end

// A keyword to associate with a photo.
@interface iPhotoKeyword : iPhotoItem

@property (copy) NSString *name;  // The string value of the keyword.


@end

// A photo.
@interface iPhotoPhoto : iPhotoItem

- (SBElementArray *) keywords;

@property NSInteger altitude;  // The GPS altitude in meters;  MAXFLOAT means no altitude information.
@property (copy) NSString *comment;  // A comment about the photo.
@property (copy) NSDate *date;  // The date of the photo.
@property (copy, readonly) NSArray *dimensions;  // The width and height of the photo in pixels.
@property (readonly) NSInteger height;  // The height of the photo in pixels.
- (NSInteger) id;  // The unique ID of the photo.
@property (copy, readonly) NSString *imageFilename;  // The name of the image file.
@property (copy, readonly) NSString *imagePath;  // The path to the image file.
@property NSInteger latitude;  // The GPS latitude in range -90.0 to 90.0;  MAXFLOAT means no GPS information.  Use reverse geocode command after setting lat/lon.
@property NSInteger longitude;  // The GPS longitude in range -180.0 to 180.0;  MAXFLOAT means no GPS information.  Measurement is taken from the prime meridian, so 'west' longitudes are negative numbers.  Use reverse geocode command after setting lat/lon.
@property (copy) NSString *name;  // The name (title) of the photo.
@property (copy, readonly) NSString *originalPath;  // The path to the original image as it was imported to iPhoto.
@property NSInteger rating;  // The start rating (0 through 5).
@property (copy, readonly) NSString *thumbnailFilename;  // The name of the thumbnail file.
@property (copy, readonly) NSString *thumbnailPath;  // The path to the thumbnail file.
@property (copy) NSString *title;  // The title (name) of the photo.
@property (readonly) NSInteger width;  // The width of the photo in pixels.


@end



/*
 * Type Definitions
 */

@interface iPhotoPrintSettings : SBObject

@property NSInteger copies;  // the number of copies of a document to be printed
@property BOOL collating;  // Should printed copies be collated?
@property NSInteger startingPage;  // the first page of the document to be printed
@property NSInteger endingPage;  // the last page of the document to be printed
@property NSInteger pagesAcross;  // number of logical pages laid across a physical page
@property NSInteger pagesDown;  // number of logical pages laid out down a physical page
@property (copy) NSDate *requestedPrintTime;  // the time at which the desktop printer should print the document
@property iPhotoEnum errorHandling;  // how errors are handled
@property (copy) NSString *faxNumber;  // for fax number
@property (copy) NSString *targetPrinter;  // for target printer

- (void) closeSaving:(iPhotoSavo)saving savingIn:(NSURL *)savingIn;  // Close an object.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (BOOL) exists;  // Verify if an object exists.
- (void) moveTo:(SBObject *)to;  // Move object(s) to a new location.
- (void) saveAs:(NSString *)as in:(NSURL *)in_;  // Save an object.
- (void) addTo:(id)to;  // Add the given object to the container.
- (void) assignKeywordString:(NSString *)string;  // Assign an existing keyword to the currently-selected photos.
- (void) autoImport;  // Start importing photos from the auto-import folder.
- (void) duplicateTo:(id)to;  // Create a duplicate of an object.
- (void) emptyTrash;  // Empty the Trash album.
- (void) importFrom:(NSString *)from forceCopy:(NSInteger)forceCopy to:(iPhotoAlbum *)to;  // Import the given path.
- (iPhotoAlbum *) newAlbumName:(NSString *)name;  // Create a new album.
- (void) nextSlide;  // Skip to previous slide in currently-playing slideshow.
- (void) pauseSlideshow;  // Pause the currently-playing slideshow.
- (void) previousSlide;  // Skip to next slide in currently-playing slideshow.
- (void) removeFrom:(id)from;  // Remove the given object from its container.
- (void) resumeSlideshow;  // Resume the currently-playing slideshow.
- (void) reverseGeocode;  // Call after setting a photo's latitude and longitude.  This command instructs iPhoto to use lat/lon to look up the country, city, point of interest, etc.
- (void) select;  // Select one or more objects.
- (void) startSlideshowAsynchronous:(NSInteger)asynchronous displayIndex:(NSInteger)displayIndex iChat:(NSInteger)iChat usingAlbum:(NSString *)usingAlbum;  // Display a slideshow with the currently-selected photos or album.
- (void) stopSlideshow;  // End the currently-playing slideshow.

@end

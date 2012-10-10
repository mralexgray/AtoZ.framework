/**
 
 NUPluginsManager
 
 \brief     Facilitates the management of a plugin architecture.

 \details   Plugins are usually implemented as bundles and their description
            should be available in the info.plist file of that bundle.
 
            Each plugin should have a unique UTType that conforms to
            com.NUascent.plugin or to a type that conforms to it.
 
 \author    Eric Methot
 \date      2012-04-13
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

extern NSString *kPluginManagerPluginIDKey;
extern NSString *kPluginManagerBundleKey;


typedef void (^NUPluginHandlerBlock)(NSString *uttypeid, NSMutableDictionary *pluginInfo);

@interface NUPluginsManager : NSObject

// -----------------------------------------------------------------------------
   #pragma mark Plugin Dictionaries
// -----------------------------------------------------------------------------

/**
 
 \brief     Returns the info dictionary for the plugin with the specified UTType.
 
 \details   The dictionary can be modified by the user.
 
 */
- (NSMutableDictionary*) pluginInfoForUTType:(NSString*) uttypeid;


// -----------------------------------------------------------------------------
   #pragma mark Plugin Handlers
// -----------------------------------------------------------------------------

/**
 
 \brief     Adds a callback to be called whenever a plugin is loaded that 
            conforms to one of the UTType identifiers in the array.
 
 \details   Only the types declared in the UTTypeConformsTo array are called.
            If a plugin conforms to more than one type in the array then
            the handler will be called once for each conforming type.
 
 */
- (void) addHandlerForPluginConformingToTypes:(NSArray*) uttypeids
                                   usingBlock:(NUPluginHandlerBlock) handler;

/**
 
 \brief     Adds a callback to be called whenever a plugin is loaded that 
            conforms to the specified UTType identifier.
 
 \details   This is a equivalent to calling `addHandlerForPluginConformingToTypes:usingBlock:`
            With an array of one type.
 
 */
- (void) addHandlerForPluginConformingToType:(NSString*) uttypeid 
                                  usingBlock:(NUPluginHandlerBlock) handler;


// -----------------------------------------------------------------------------
   #pragma mark Loading Plugins
// -----------------------------------------------------------------------------

/**
 
 \brief     Loads a plugin manually from a dictionary.
 
 \details   This dictionary usually comes from an Info.plist file. 
            If it does not then you should ensure that the UTTypes for the plugin 
            has been declared. Once loaded, the following additional keys will 
            have been made available:
 
            1. bundle: an instance of the bundle for that declared the plugin.
 
 */
- (void) loadPlugin:(NSDictionary*) pluginInfo;


/**
 
 \brief     Loads all plugins within a bundle that conform to the specified type.

 \details   Each plugin should declare an associated UTTypeIdentifier, which 
            usually conforms to a known application plugin type such as 
            `com.company.myapp.plugin`. All the types exported by the bundle 
            that conform te the specified uttypeid are loaded as plugins. 
            Plugins are declared within the UTExportedTypeDeclarations of the 
            bundles Info.plist file. 
 
            Example Declaration:
 
            `<key>MyPlugins</key>
             <array>
                 <dict>
                     <key>PluginID</key>
                     <string>com.popchartsapp.plugin.tab.fileBrowser</string>
                     <key>PluginName</key>
                     <string>File Browser</string>
                     <key>PluginImage</key>
                     <string></string>
                     <key>PluginDescription</key>
                     <string>The file browser allows the user to navigate the filesystem within the app without having to open a new window.</string>
                     <key>UTTypeConformsTo</key>
                     <array>
                     <string>com.popchartsapp.plugin.tab</string>
                     </array>
                     <key>PluginViewNib</key>
                     <string>CCFileBrowser</string>
                 </dict>
             </array>`
 
 */
- (void) loadPluginsInBundle:(NSBundle*) bundle 
      fromDictionariesForKey:(NSString*) pluginsKey
            conformingToType:(NSString*) uttypeid;

/**
 
 \brief     Loads all bundles within the list of directories that have 
            the given extension and that conform to the given type.
 
 */
- (void) loadPluginBundlesInPaths:(NSArray*) searchURLs 
                    withExtension:(NSString*) extension
           fromDictionariesForKey:(NSString*) pluginsKey
                 conformingToType:(NSString*) uttypeid;

@end

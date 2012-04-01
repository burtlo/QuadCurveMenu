
require 'xcoder'

project_name = 'QuadCurve'
universal_framework_name = 'QuadCurve'
# All paths specified are the logical paths within the Xcode Project

source_filenames = [ 'QuadCurve/Classes/QuadCurveMenu.m',
  'QuadCurve/Classes/QuadCurveMenuItem.m',
  'QuadCurve/Classes/Data Sources/QuadCurveDefaultDataSource.m',
  'QuadCurve/Classes/MenuItem Factories/QuadCurveDefaultMenuItemFactory.m',
  'QuadCurve/Classes/MenuItem Factories/AGMedallionView.m',
  'QuadCurve/Classes/Animations/QuadCurveShrinkAnimation.m',
  'QuadCurve/Classes/Animations/QuadCurveBlowupAnimation.m',
  'QuadCurve/Classes/Animations/QuadCurveItemCloseAnimation.m',
  'QuadCurve/Classes/Animations/QuadCurveItemExpandAnimation.m',
  'QuadCurve/Classes/Directors/QuadCurveLinearDirector.m',
  'QuadCurve/Classes/Directors/QuadCurveRadialDirector.m' ]
  
public_headerfilenames = [ 'QuadCurve/Classes/QuadCurveMenu.h',
    'QuadCurve/Classes/QuadCurveMenuItem.h',
    'QuadCurve/Classes/Data Sources/QuadCurveDataSourceDelegate.h',
    'QuadCurve/Classes/Data Sources/QuadCurveDefaultDataSource.h',
    'QuadCurve/Classes/MenuItem Factories/QuadCurveMenuItemFactory.h',
    'QuadCurve/Classes/MenuItem Factories/QuadCurveDefaultMenuItemFactory.h',
    'QuadCurve/Classes/MenuItem Factories/AGMedallionView.h',
    'QuadCurve/Classes/Animations/QuadCurveAnimation.h',
    'QuadCurve/Classes/Animations/QuadCurveShrinkAnimation.h',
    'QuadCurve/Classes/Animations/QuadCurveBlowupAnimation.h',
    'QuadCurve/Classes/Animations/QuadCurveItemCloseAnimation.h',
    'QuadCurve/Classes/Animations/QuadCurveItemExpandAnimation.h',
    'QuadCurve/Classes/Directors/QuadCurveMotionDirector.h',
    'QuadCurve/Classes/Directors/QuadCurveLinearDirector.h',
    'QuadCurve/Classes/Directors/QuadCurveRadialDirector.h' ]
    
project_headerfilenames = [ 'QuadCurve/Supporting Files/QuadCurve-Prefix.pch' ]


project = Xcode.project project_name
  
project.create_target universal_framework_name, :bundle do |target|
  
  target.create_build_phase :sources do |source|
  
    source_filenames.each do |filename|
      source.add_build_file project.file(filename)
    end
  
  
  end
  
  target.create_build_phase :copy_headers do |headers|
    
    public_headerfilenames.each do |public_headerfilename|
      headers.add_build_file_with_public_privacy project.file(public_headerfilename)
    end

    project_headerfilenames.each do |project_headerfilename|
      headers.add_build_file project.file(project_headerfilename)
    end
  end
  
  target.create_configurations :release do |config|
    config.always_search_user_paths = false
    config.architectures = [ "$(ARCHS_STANDARD_32_BIT)", 'armv6' ]
    config.copy_phase_strip = true
    config.dead_code_stripping = false
    config.debug_information_format = "dwarf-with-dsym"
    config.c_language_standard = 'gnu99'
    config.enable_objc_exceptions = true
    config.generate_debugging_symbols = false
    config.precompile_prefix_headers = false
    config.gcc_version = 'com.apple.compilers.llvm.clang.1_0'
    config.warn_64_to_32_bit_conversion = true
    config.warn_about_missing_prototypes = true
    config.install_path = "$(LOCAL_LIBRARY_DIR)/Bundles"
    config.link_with_standard_libraries = false
    config.mach_o_type = 'mh_object'
    config.macosx_deployment_target = '10.7'
    config.product_name = '$(TARGET_NAME)'
    config.sdkroot = 'iphoneos'
    config.valid_architectures = '$(ARCHS_STANDARD_32_BIT)'
    config.wrapper_extension = 'framework'
    config.info_plist_location = ""
    config.prefix_header = ""
    config.save!
  end
  
end

project.create_target("Universal #{universal_framework_name}",:aggregate) do |target|
  
  target.product_name = "Universal #{universal_framework_name}"
  
  target.add_dependency project.target(universal_framework_name)

  target.create_configurations :release
  
  target.create_build_phase :run_script do |script|
    script.shell_script = "# Sets the target folders and the final framework product.\nFMK_NAME=#{universal_framework_name}\nFMK_VERSION=A\n\n# Install dir will be the final output to the framework.\n# The following line create it in the root folder of the current project.\nINSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework\n\n# Working dir will be deleted after the framework creation.\nWRK_DIR=build\nDEVICE_DIR=${WRK_DIR}/Release-iphoneos/${FMK_NAME}.framework\nSIMULATOR_DIR=${WRK_DIR}/Release-iphonesimulator/${FMK_NAME}.framework\n\n# Building both architectures.\nxcodebuild -configuration \"Release\" -target \"${FMK_NAME}\" -sdk iphoneos\nxcodebuild -configuration \"Release\" -target \"${FMK_NAME}\" -sdk iphonesimulator\n\n# Cleaning the oldest.\nif [ -d \"${INSTALL_DIR}\" ]\nthen\nrm -rf \"${INSTALL_DIR}\"\nfi\n\n# Creates and renews the final product folder.\nmkdir -p \"${INSTALL_DIR}\"\nmkdir -p \"${INSTALL_DIR}/Versions\"\nmkdir -p \"${INSTALL_DIR}/Versions/${FMK_VERSION}\"\nmkdir -p \"${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources\"\nmkdir -p \"${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers\"\n\n# Creates the internal links.\n# It MUST uses relative path, otherwise will not work when the folder is copied/moved.\nln -s \"${FMK_VERSION}\" \"${INSTALL_DIR}/Versions/Current\"\nln -s \"Versions/Current/Headers\" \"${INSTALL_DIR}/Headers\"\nln -s \"Versions/Current/Resources\" \"${INSTALL_DIR}/Resources\"\nln -s \"Versions/Current/${FMK_NAME}\" \"${INSTALL_DIR}/${FMK_NAME}\"\n\n# Copies the headers and resources files to the final product folder.\ncp -R \"${DEVICE_DIR}/Headers/\" \"${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/\"\ncp -R \"${DEVICE_DIR}/\" \"${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/\"\n\n# Removes the binary and header from the resources folder.\nrm -r \"${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/Headers\" \"${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/${FMK_NAME}\"\n\n# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.\nlipo -create \"${DEVICE_DIR}/${FMK_NAME}\" \"${SIMULATOR_DIR}/${FMK_NAME}\" -output \"${INSTALL_DIR}/Versions/${FMK_VERSION}/${FMK_NAME}\"\n\nrm -r \"${WRK_DIR}\""
  end

end

project.save!
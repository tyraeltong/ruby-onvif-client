require_relative '../action'

module ONVIF
    module PtzAction
        class AbsoluteMove < Action
            # options 的结构  
            # {
            #     profile_token: "xxxxxxx",//[ReferenceToken] A reference to the MediaProfile where the operation should take place.
            #     position: {
            #         pan_tilt: { //optional
            #             x: 1, //[float]
            #             y: 2, //[float]
            #             space: "http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace", //[anyURI]
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/TranslationGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/VelocityGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/GenericSpeedSpace
            #         },
            #         zoom: { //optional
            #             x: 1,//[float]
            #             space: "http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace",//[anyURI]
            #         }
            #     }
            #     speed: {  //optional
            #         pan_tilt: { //optional
            #             x: 1, //[float]
            #             y: 2, //[float]
            #             space: "http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace", //[anyURI]
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/TranslationGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/VelocityGenericSpace
            #             // http://www.onvif.org/ver10/tptz/PanTiltSpaces/GenericSpeedSpace
            #         },
            #         zoom: { //optional
            #             x: 1,//[float]
            #             space: "http://www.onvif.org/ver10/tptz/PanTiltSpaces/PositionGenericSpace",//[anyURI]
            #         }
            #     }
            # }
            def run options, cb
                message = create_ptz_onvif_message
                message.body =  ->(xml) do
                    xml.wsdl(:AbsoluteMove) do
                        xml.wsdl :ProfileToken, options[:profile_token]
                        xml.wsdl(:Position) do
                            unless options[:position][:pan_tilt].nil?
                                xml.wsdl :PanTilt, {
                                    "x" => options[:position][:pan_tilt][:x],
                                    "y" => options[:position][:pan_tilt][:y],
                                    "space" => options[:position][:pan_tilt][:space]
                                }
                            end
                            unless options[:position][:zoom].nil?
                                xml.wsdl :Zoom, {
                                    "x" => options[:position][:zoom][:x],
                                    "space" => options[:position][:zoom][:space]
                                }
                            end
                        end
                        unless options[:speed].nil?
                            xml.wsdl(:Speed) do
                                unless options[:speed][:pan_tilt].nil?
                                    xml.wsdl :PanTilt, {
                                        "x" => options[:speed][:pan_tilt][:x],
                                        "y" => options[:speed][:pan_tilt][:y],
                                        "space" => options[:speed][:pan_tilt][:space]
                                    }
                                end
                                unless options[:speed][:zoom].nil?
                                    xml.wsdl :Zoom, {
                                        "x" => options[:speed][:zoom][:x],
                                        "space" => options[:speed][:zoom][:space]
                                    }
                                end
                            end
                        end
                    end
                end
                send_message message do |success, result|
                    callback cb, success, result
                end
            end
        end
    end
end
#ifndef CORE_CMDLINE_PARSER_H
#define CORE_CMDLINE_PARSER_H

#include <string>
#include <vector>
#include <map>
#include <set>
#include <algorithm>
#include <sstream>

// Simple command-line parser to replace QCommandLineParser

namespace core {

class CommandLineOption {
public:
    CommandLineOption() = default;

    // Constructor with short option, long option, and description
    CommandLineOption(const std::string& shortOpt, const std::string& longOpt, const std::string& desc)
        : shortName_(shortOpt), longName_(longOpt), description_(desc), takesValue_(false) {}

    // Constructor with short option, long option, description, and value name (for options that take values)
    CommandLineOption(const std::string& shortOpt, const std::string& longOpt,
                      const std::string& desc, const std::string& valueName)
        : shortName_(shortOpt), longName_(longOpt), description_(desc),
          valueName_(valueName), takesValue_(true) {}

    const std::string& shortName() const { return shortName_; }
    const std::string& longName() const { return longName_; }
    const std::string& description() const { return description_; }
    const std::string& valueName() const { return valueName_; }
    bool takesValue() const { return takesValue_; }

private:
    std::string shortName_;
    std::string longName_;
    std::string description_;
    std::string valueName_;
    bool takesValue_ = false;
};

class CommandLineParser {
public:
    CommandLineParser() = default;

    void setApplicationDescription(const std::string& desc) {
        description_ = desc;
    }

    void addHelpOption() {
        addOption(CommandLineOption("h", "help", "Displays this help"));
        helpAdded_ = true;
    }

    void addVersionOption() {
        addOption(CommandLineOption("v", "version", "Displays version information"));
        versionAdded_ = true;
    }

    void addOption(const CommandLineOption& option) {
        options_.push_back(option);
        if (!option.shortName().empty()) {
            shortToLong_[option.shortName()] = option.longName();
        }
        takesValue_[option.longName()] = option.takesValue();
    }

    // Process command line arguments
    // Call this with argc, argv from main
    bool process(int argc, char* argv[]) {
        programName_ = argv[0];

        for (int i = 1; i < argc; ++i) {
            std::string arg = argv[i];

            if (arg.empty()) continue;

            // Long option: --option or --option=value
            if (arg.substr(0, 2) == "--") {
                std::string optName = arg.substr(2);
                std::string optValue;

                // Check for --option=value format
                size_t eqPos = optName.find('=');
                if (eqPos != std::string::npos) {
                    optValue = optName.substr(eqPos + 1);
                    optName = optName.substr(0, eqPos);
                }

                if (optName == "help" && helpAdded_) {
                    showHelp_ = true;
                    return true;
                }
                if (optName == "version" && versionAdded_) {
                    showVersion_ = true;
                    return true;
                }

                // Check if option takes a value
                if (takesValue_.count(optName) && takesValue_[optName]) {
                    if (optValue.empty() && i + 1 < argc) {
                        optValue = argv[++i];
                    }
                    values_[optName] = optValue;
                }
                setOptions_.insert(optName);
            }
            // Short option: -o or -o value
            else if (arg[0] == '-' && arg.length() > 1 && arg[1] != '-') {
                // Handle combined short options like -fv
                for (size_t j = 1; j < arg.length(); ++j) {
                    std::string shortOpt(1, arg[j]);

                    if (shortOpt == "h" && helpAdded_) {
                        showHelp_ = true;
                        return true;
                    }
                    if (shortOpt == "v" && versionAdded_) {
                        showVersion_ = true;
                        return true;
                    }

                    std::string longOpt = shortOpt;
                    if (shortToLong_.count(shortOpt)) {
                        longOpt = shortToLong_[shortOpt];
                    }

                    // Check if option takes a value (only for last short opt in combined)
                    if (takesValue_.count(longOpt) && takesValue_[longOpt]) {
                        if (j == arg.length() - 1 && i + 1 < argc) {
                            values_[longOpt] = argv[++i];
                        }
                    }
                    setOptions_.insert(longOpt);
                }
            }
            // Positional argument
            else {
                positionalArgs_.push_back(arg);
            }
        }
        return true;
    }

    // Check if an option was set
    bool isSet(const CommandLineOption& option) const {
        return setOptions_.count(option.longName()) > 0 ||
               setOptions_.count(option.shortName()) > 0;
    }

    bool isSet(const std::string& optName) const {
        return setOptions_.count(optName) > 0;
    }

    // Get option value
    std::string value(const CommandLineOption& option) const {
        auto it = values_.find(option.longName());
        if (it != values_.end()) {
            return it->second;
        }
        return "";
    }

    std::string value(const std::string& optName) const {
        auto it = values_.find(optName);
        if (it != values_.end()) {
            return it->second;
        }
        return "";
    }

    // Get positional arguments
    const std::vector<std::string>& positionalArguments() const {
        return positionalArgs_;
    }

    // Check if help/version was requested
    bool helpRequested() const { return showHelp_; }
    bool versionRequested() const { return showVersion_; }

    // Generate help text
    std::string helpText() const {
        std::ostringstream ss;
        ss << "Usage: " << programName_ << " [options]\n\n";

        if (!description_.empty()) {
            ss << description_ << "\n\n";
        }

        ss << "Options:\n";
        for (const auto& opt : options_) {
            ss << "  ";
            if (!opt.shortName().empty()) {
                ss << "-" << opt.shortName();
                if (!opt.longName().empty()) {
                    ss << ", ";
                }
            }
            if (!opt.longName().empty()) {
                ss << "--" << opt.longName();
            }
            if (opt.takesValue()) {
                ss << " <" << opt.valueName() << ">";
            }
            ss << "\n        " << opt.description() << "\n";
        }
        return ss.str();
    }

private:
    std::string description_;
    std::string programName_;
    std::vector<CommandLineOption> options_;
    std::map<std::string, std::string> shortToLong_;
    std::map<std::string, bool> takesValue_;
    std::set<std::string> setOptions_;
    std::map<std::string, std::string> values_;
    std::vector<std::string> positionalArgs_;
    bool helpAdded_ = false;
    bool versionAdded_ = false;
    bool showHelp_ = false;
    bool showVersion_ = false;
};

} // namespace core

// Core-prefixed typedef (always available, no conflicts)
using CoreCommandLineParser = core::CommandLineParser;
using CoreCommandLineOption = core::CommandLineOption;

#endif // CORE_CMDLINE_PARSER_H

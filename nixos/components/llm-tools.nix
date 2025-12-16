{ config, pkgs, lib, llm-agents, ... }:
let
  cfg = config.roles.llm-tools;
in
{
  options.roles.llm-tools = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enable LLM agent tools like Claude Code, OpenCode, etc.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with llm-agents; [
      claude-code
      opencode
      gemini-cli
    ];
  };
}

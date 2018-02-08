package com.foo.job

import java.util.logging.Logger

import com.twitter.app.FlagParseException
import com.twitter.app.FlagUsageError
import com.twitter.app.Flags

trait Job {
  protected val Log: Logger = Logger.getLogger(getClass.getName)
  protected val Name: String = getClass.getName.stripSuffix("$")

  protected val flag: Flags =
    new Flags(this.getClass.getName, includeGlobal = true, failFastUntilParsed = true)

  /**
    * Users should override this method with their Spark job logic.
    */
  def run(): Unit

  def main(args: Array[String]): Unit = {
    flag.parseArgs(args, allowUndefinedFlags = false) match {
      case Flags.Ok(remainder) =>
      case Flags.Help(usage) => throw FlagUsageError(usage)
      case Flags.Error(reason) => throw FlagParseException(reason)
    }

    Log.info(s"Starting job $Name")
    run()
    Log.info(s"Completed job $Name")
  }
}

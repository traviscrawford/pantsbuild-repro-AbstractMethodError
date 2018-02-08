package com.foo.fancyjob

import com.foo.job.Job

trait FancyJob extends Job {

  private val example = flag[String]("example", default = "hello", help = "Example flag")

  override def run(): Unit = {
    Log.info("hello world")
    Log.info(example())
  }
}

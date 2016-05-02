// scalastyle:off println
package org.apache.spark.examples.mllib

import scopt.OptionParser

import org.apache.spark.SparkContext._
import org.apache.spark.mllib.linalg.Vectors
import org.apache.spark.mllib.linalg.distributed.{MatrixEntry, RowMatrix}
import org.apache.spark.{SparkConf, SparkContext}

/**
 * We need data in the form : 
 * Movies or clusters along the columns
 * and User ids along the rows. 
 * For User similarity, the we'll need transpose of this matrix.
 * We use cosine similarity to calculate similarity.
 *
 */
object CosineSimilarity {
  case class Params(inputFile: String = null, threshold: Double = 0.1)
    extends AbstractParams[Params]

  def main(args: Array[String]) {
    val defaultParams = Params()

    val parser = new OptionParser[Params]("CosineSimilarity") {
      head("CosineSimilarity: an example app.")
      opt[Double]("threshold")
        .required()
        .text(s"threshold similarity: to tradeoff computation vs quality estimate")
        .action((x, c) => c.copy(threshold = x))
      arg[String]("<inputFile>")
        .required()
        .text(s"input file, one row per line, space-separated")
        .action((x, c) => c.copy(inputFile = x))
      note(
        """
         Can be run using a command line spark
        """.stripMargin)
    }

    parser.parse(args, defaultParams).map { params =>
      run(params)
    } getOrElse {
      System.exit(1)
    }
  }

  def run(params: Params) {
    val conf = new SparkConf().setAppName("UserAndMovieSimilarity")
    val sc = new SparkContext(conf)

    // Load and parse the data file.
    val rows = sc.textFile(params.inputFile).map { line =>
      val values = line.split(' ').map(_.toDouble)
      Vectors.dense(values)
    }.cache()
    val mat = new RowMatrix(rows)


    // Compute similar columns with estimation using DIMSUM
    val approx = mat.columnSimilarities(params.threshold)

	approx.entries().saveAsTextFile("similarity_matrix.txt");

	//Optional code to compare performance
	//Comment this out, only for testing
    val exact = mat.columnSimilarities()
    val exactEntries = exact.entries.map { case MatrixEntry(i, j, u) => ((i, j), u) }
    val approxEntries = approx.entries.map { case MatrixEntry(i, j, v) => ((i, j), v) }
    val MAE = exactEntries.leftOuterJoin(approxEntries).values.map {
      case (u, Some(v)) =>
        math.abs(u - v)
      case (u, None) =>
        math.abs(u)
    }.mean()

    println(s"Average absolute error in estimate is: $MAE")

    sc.stop()
  }
}
// scalastyle:on println

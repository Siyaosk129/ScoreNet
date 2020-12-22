# ScoreNet

Project name: ScoreNet: A neural network-based post-processing model for identifying epileptic seizure onset and offset in EEGs

Developers: Poomipat Boonyakitanont, Apiwat Lek-uthai, and Jitkomut Songsiri

This project is to provide codes for training, testing and evaluating the ScoreNet in the manuscript

P. Boonyakitanont, A. Lek-uthai, and J. Songsiri, ScoreNet: A neural network-based post-processing model for identifying epileptic seizure onset and offset in EEGs

The main functions are
1. main_code.m for implementing of training and testing the ScoreNet
2. forward_compute.m for predicting the output of the ScoreNet
3. loss_grad.m for calculating the loss and its gradients w.r.t. predictions
4. gradient_update.m for determining the gradient of the loss function w.r.t. the model parameters
5. conj_grad.m for updating the ScoreNet parameters using a conjugate gradient method
6. onoff_eval.m for evaluating the ScoreNet

User can run main_code.m to see an example of training and testing the ScoreNet.

The following scripts for plotting figures displaying performance metrics in the manuscript are in the folder publication_graphic
1. performance_visualization.m for plotting figures in the manuscript
2. plot_scatter2.m for scatter plot of EL-index, GDR, and mean absolute latency
3. categorical_bar.m for creating grouped bar graphs
4. bar_with_error.m for creating grouped bar graphs overlayed by error bars

## Description of provided data
Predictions used in the example are obtained from all classifiers used in the manuscript.
The predictions are stored in prediction_XX_YY.csv in the folder of which the name ends with _result where XX and YY are case of patient and the record number.
In the prediction file, each row indicates a prediction at each time step of each record where the record name is indicated by the first row. The record name that is the same as the file name is the test record, and the other records are for training.

All onset and offset labels are stored in the folder chb-mit_onsetoffset_label, and each file name ends with the patient case. In the file, each row corresponds to predictions of an EEG record sorted by number and alphabet. For example, predictions of the record chb23_06 are stored in the first row, and predictions of the record chb23_10 are stored in the fifth row. The column A in the file indicates lengths of EEG, the columns B to G consist of annotated seizure onsets, and the columns H to M contain labelled seizure offsets.

